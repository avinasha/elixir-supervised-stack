defmodule SupervisedStack.Supervisor do
  use Supervisor

  def start_link(initial_list) do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, [])
    start_workers(sup, initial_list)
    result
  end

  def start_workers(sup, initial_list) do
    {:ok, stash} = Supervisor.start_child(sup, worker(SupervisedStack.Stash, [initial_list]))
    Supervisor.start_child(sup, supervisor(SupervisedStack.SubSupervisor, [stash]))
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end
