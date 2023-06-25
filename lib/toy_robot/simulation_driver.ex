defmodule ToyRobot.SimulationDriver do
  alias ToyRobot.{Table, Robot, SimulationDriver}
  defstruct table: %Table{}, robot: %Robot{}

  @doc """
  Simulates placing a robot on the table.

  ## Examples

  When the robot is placed in a valid position:

      iex> alias ToyRobot.{Robot, Table, SimulationDriver}
      [ToyRobot.Robot, ToyRobot.Table, ToyRobot.SimulationDriver]
      iex> table = %Table{north_boundary: 4, east_boundary: 4}
      %Table{north_boundary: 4, east_boundary: 4}
      iex> SimulationDriver.place(table, Robot.new(0, 0, :north))
      {
        :ok,
        %ToyRobot.SimulationDriver{
          table: table,
          robot: %Robot{x: 0, y: 0, f: :north}
        }
      }

  When the robot is placed in an invalid position:

      iex> alias ToyRobot.{Robot, Table, SimulationDriver}
      [ToyRobot.Robot, ToyRobot.Table, ToyRobot.SimulationDriver]
      iex> table = %Table{north_boundary: 4, east_boundary: 4}
      %Table{north_boundary: 4, east_boundary: 4}
      iex> SimulationDriver.place(table, Robot.new(0, 5, :north))
      {
        :error,
        :invalid_placement
      }
  """
  def place(table, %{x: _, y: _, f: _} = robot) when is_struct(table, Table) do
    if table |> Table.valid_position?(robot) do
      {
        :ok,
        %__MODULE__{
          table: table,
          robot: robot
        }
      }
    else
      {:error, :invalid_placement}
    end
  end

  @doc """
  Moves the robot forward one space in the direction that it is facing, unless that position is past the bou\ ndaries of the table.

  ## Examples

  ### A valid movement

      iex> alias ToyRobot.{Robot, Table, SimulationDriver}
      [ToyRobot.Robot, ToyRobot.Table, ToyRobot.SimulationDriver]
      iex> table = %Table{north_boundary: 4, east_boundary: 4}
      %Table{north_boundary: 4, east_boundary: 4}
      iex> simulation = %SimulationDriver{table: table, robot: Robot.new(0, 0, :north)}
      iex> simulation |> SimulationDriver.move
      {:ok, %SimulationDriver{table: table, robot: %Robot{x: 0, y: 1, f: :north}}}
  """
  def move(%SimulationDriver{robot: robot, table: table} = simulation) do
    with moved_robot <- robot |> Robot.move(),
         true <- table |> Table.valid_position?(moved_robot) do
      {
        :ok,
        %SimulationDriver{
          simulation
          | robot: moved_robot
        }
      }
    else
      false -> {:error, :at_table_boundary}
    end
  end

  @doc """
  Shows where the robot will move next.

  ## Examples

      iex> alias ToyRobot.{Robot, Table, SimulationDriver}
      [ToyRobot.Robot, ToyRobot.Table, ToyRobot.SimulationDriver]
      iex> table = %Table{north_boundary: 5, east_boundary: 5}
      %Table{north_boundary: 5, east_boundary: 5}
      iex> simulation = %SimulationDriver{table: table, robot: %Robot{x: 0, y: 0, f: :north}}
      iex> simulation |> SimulationDriver.next_position
      %Robot{x: 0, y: 1, f: :north}
  """
  def next_position(%SimulationDriver{robot: robot}) do
    robot |> Robot.move
  end

  @doc """
  Turns the robot right.
  """
  def turn_right(%SimulationDriver{robot: robot} = simulation) do
    {:ok,
     %SimulationDriver{
       simulation
       | robot: robot |> Robot.turn_right()
     }
    }
  end

  @doc """
  Turns the robot left.
  """
  def turn_left(%SimulationDriver{robot: robot} = simulation) do
    {
      :ok,
      %SimulationDriver{
        simulation
        | robot: robot |> Robot.turn_left()
      }
    }
  end

  @doc """
  Returns the robot's current position.
  """
  def report(%SimulationDriver{robot: robot}), do: robot
end
