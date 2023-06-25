defmodule ToyRobot.CommandRunnerTest do
  alias ToyRobot.{SimulationDriver, CommandRunner}
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  test "Handles valid placement command" do
    %SimulationDriver{robot: robot} = CommandRunner.run([{:place, %{x: 1, y: 2, f: :north}}])
    assert robot.x == 1
    assert robot.y == 2
    assert robot.f == :north
  end

  test "Handles invalid placement command" do
    assert CommandRunner.run([{:place, %{x: 10, y: 10, f: :north}}]) == nil
  end

  test "ignores commands until a valid placement" do
    %SimulationDriver{robot: robot} = [:move, {:place, %{x: 1, y: 2, f: :north}}] |> CommandRunner.run()
    assert robot.x == 1
    assert robot.y == 2
    assert robot.f == :north
  end

  test "handles a place + move command" do
    %SimulationDriver{robot: robot} = [{:place, %{x: 1, y: 2, f: :north}}, :move] |> CommandRunner.run()
    assert robot.x == 1
    assert robot.y == 3
    assert robot.f == :north
  end

  test "handles a place + invalid move command" do
    %SimulationDriver{robot: robot} = [{:place, %{x: 1, y: 4, f: :north}}, :move] |> CommandRunner.run()
    assert robot.x == 1
    assert robot.y == 4
    assert robot.f == :north
  end

  test "handles a place + turn left command" do
    %SimulationDriver{robot: robot} = [{:place, %{x: 1, y: 2, f: :north}}, :turn_left] |> CommandRunner.run()
    assert robot.x == 1
    assert robot.y == 2
    assert robot.f == :west
  end

  test "handles a place + turn right command" do
    %SimulationDriver{robot: robot} = [{:place, %{x: 1, y: 2, f: :north}}, :turn_right] |> CommandRunner.run()
    assert robot.x == 1
    assert robot.y == 2
    assert robot.f == :east
  end

  test "handles a place + report command" do
    commands = [{:place, %{x: 1, y: 2, f: :north}}, :report]
    output = capture_io fn ->
      CommandRunner.run(commands)
    end
    assert output |> String.trim == "The robot is at (1, 2) and is facing NORTH"
  end

  test "handles a place + invalid command" do
    %SimulationDriver{robot: robot} = [{:place, %{x: 1, y: 2, f: :north}}, {:invalid, "EXTERMINATE"}] |> CommandRunner.run()
    assert robot.x == 1
    assert robot.y == 2
    assert robot.f == :north
  end
end
