defmodule ToyRobot.Robot do
  defstruct x: 0, y: 0, f: :north

  @doc """
  Moves the robot forward one space.

  ## Examples

      iex> alias ToyRobot.Robot
      ToyRobot.Robot
      iex> robot = Robot.new()
      %ToyRobot.Robot{x: 0, y: 0, f: :north}
      iex> robot |> Robot.move
      %ToyRobot.Robot{x: 0, y: 1, f: :north}
      iex> robot |> Robot.move |> Robot.move |> Robot.move
      %ToyRobot.Robot{x: 0, y: 3, f: :north}
      iex> robot = Robot.new(0, 0, :east)
      %ToyRobot.Robot{x: 0, y: 0, f: :east}
      iex> robot |> Robot.move
      %ToyRobot.Robot{x: 1, y: 0, f: :east}
      iex> robot |> Robot.move |> Robot.move |> Robot.move
      %ToyRobot.Robot{x: 3, y: 0, f: :east}
  """
  def move(%{x: x, y: y, f: f} = robot) do
    case f do
      :north ->
        %{robot | y: y + 1}
      :south ->
        %{robot | y: y - 1}
      :east ->
        %{robot | x: x + 1}
      :west ->
        %{robot | x: x - 1}
    end
  end

  @doc """
  Turns the robot left

  ## Examples
      iex> alias ToyRobot.Robot
      ToyRobot.Robot
      iex> robot = Robot.new()
      %ToyRobot.Robot{f: :north}
      iex> robot |> Robot.turn_left
      %ToyRobot.Robot{f: :west}
  """
  def turn_left(%{x: x, y: y, f: f}) do
    new_direction = case f do
      :north -> :west
      :west -> :south
      :south -> :east
      :east -> :north
    end
    %ToyRobot.Robot{
      x: x, y: y, f: new_direction
    }
  end

  @doc """
  Turns the robot right

  ## Examples
      iex> alias ToyRobot.Robot
      ToyRobot.Robot
      iex> robot = Robot.new()
      %ToyRobot.Robot{f: :north}
      iex> robot |> Robot.turn_right
      %ToyRobot.Robot{f: :east}
  """
  def turn_right(%{x: x, y: y, f: f}) do
    new_direction = case f do
      :north -> :east
      :east -> :south
      :south -> :west
      :west -> :north
    end
    %ToyRobot.Robot{
      x: x, y: y, f: new_direction
    }
  end

  def new(x \\ 0, y \\ 0, face \\ :north) do
    %ToyRobot.Robot{
      x: x, y: y, f: face
    }
  end
end
