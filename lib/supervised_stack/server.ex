defmodule SupervisedStack.Server do
  use GenServer
  
  ####
  # Public API methods
  
  def start_link(stash_pid) do
    GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end

  def show do
    GenServer.call(__MODULE__, :show)
  end

  def push(element) when is_integer(element) do
    GenServer.cast(__MODULE__, {:push, element})
  end

  def push(_element) do
    raise "not an integer"
  end

  def pop do
    GenServer.call(__MODULE__,:pop)
  end

  ####
  # GenServer Implementation

  def init(stash_pid) do
    current_stack = SupervisedStack.Stash.get_value stash_pid
    { :ok, {current_stack, stash_pid} }
  end

  def handle_call({:init, list}, _from, {_stack, stash_pid}) do
    {:reply, list, {list, stash_pid} }
  end

  def handle_call(:pop, _from, {stack, stash_pid}) do
    [head|tail] = stack
    {:reply, head, {tail, stash_pid} }
  end

  def handle_call(:show, _from, {stack, stash_pid}) do
    {:reply, stack, {stack, stash_pid} }
  end
  
  def handle_cast({:push, number}, {stack, stash_pid}) do
    {:noreply, {[number| stack], stash_pid}}
  end

  def terminate(_reason, {stack, stash_pid}) do
    SupervisedStack.Stash.save_value(stash_pid, stack)
  end
end
