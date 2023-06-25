defmodule ToyRobot.Game.Player do
  use GenServer
  alias ToyRobot.Game.Players
  alias ToyRobot.SimulationDriver

  def start_link([registry_id: registry_id, table: table, robot: robot, name: name]) do
    name = process_name(registry_id, name)
    GenServer.start_link(__MODULE__, [registry_id: registry_id, table: table, robot: robot, name: name], name: name)
  end

  def process_name(registry_id, name), do: {:via, Registry, {registry_id, name}}

  def report(player_pid) do
    GenServer.call(player_pid, :report)
  end

  def move(player_pid) do
    GenServer.cast(player_pid, :move)
  end

  def next_position(player_pid) do
    GenServer.call(player_pid, :next_position)
  end

  @impl GenServer
  def init([registry_id: registry_id, table: table, robot: robot, name: name]) do
    robot =
      registry_id
      |> Players.all
      |> Players.except(name)
      |> Players.positions
      |> Players.change_position_if_occupied(table, robot)
    simulation = %SimulationDriver{
      robot: robot,
      table: table
    }
    {:ok, simulation}
  end

  def init([table: table, robot: robot]) do
    simulation = %SimulationDriver{
      robot: robot,
      table: table
    }
    {:ok, simulation}
  end

  @impl GenServer
  def handle_call(:report, _from, simulation) do
    {:reply, simulation |> SimulationDriver.report, simulation}
  end

  @impl GenServer
  def handle_call(:next_position, _from, simulation) do
    next_position = simulation |> SimulationDriver.next_position()
    {:reply, next_position, simulation}
  end

  @impl GenServer
  def handle_cast(:move, simulation) do
    {:ok, new_simulation} = simulation |> SimulationDriver.move
    {:noreply, new_simulation}
  end
end
