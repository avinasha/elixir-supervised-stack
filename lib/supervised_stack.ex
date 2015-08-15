defmodule SupervisedStack do
  use Application

  def start(_type, initial_list) do
    {:ok, _pid} = SupervisedStack.Supervisor.start_link(initial_list)
  end
end
