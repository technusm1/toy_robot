defmodule ToyRobot.RobotTest do
  use ExUnit.Case
  doctest ToyRobot.Robot
  alias ToyRobot.Robot

  describe "When robot is facing north" do
    setup do
      {:ok, %{robot: ToyRobot.Robot.new(0, 0, :north)}}
    end

    test "it moves one space north", %{robot: robot} do
      robot = robot |> Robot.move
      assert robot.y == 1
    end

    test "turns left to face west", %{robot: robot} do
      robot = robot |> Robot.turn_left
      assert robot.f == :west
    end

    test "turns right to face east", %{robot: robot} do
      robot = robot |> Robot.turn_right
      assert robot.f == :east
    end
  end

  describe "When robot is facing south" do
    setup do
      {:ok, %{robot: ToyRobot.Robot.new(0, 1, :south)}}
    end

    test "it moves one space south", %{robot: robot} do
      robot = robot |> Robot.move
      assert robot.y == 0
    end

    test "turns left to face east", %{robot: robot} do
      robot = robot |> Robot.turn_left
      assert robot.f == :east
    end

    test "turns right to face west", %{robot: robot} do
      robot = robot |> Robot.turn_right
      assert robot.f == :west
    end
  end

  describe "When robot is facing east" do
    setup do
      {:ok, %{robot: ToyRobot.Robot.new(0, 0, :east)}}
    end

    test "it moves one space east", %{robot: robot} do
      robot = robot |> Robot.move
      assert robot.x == 1
    end

    test "turns left to face north", %{robot: robot} do
      robot = robot |> Robot.turn_left
      assert robot.f == :north
    end

    test "turns right to face south", %{robot: robot} do
      robot = robot |> Robot.turn_right
      assert robot.f == :south
    end
  end

  describe "When robot is facing west" do
    setup do
      {:ok, %{robot: ToyRobot.Robot.new(1, 0, :west)}}
    end

    test "it moves one space west", %{robot: robot} do
      robot = robot |> Robot.move
      assert robot.x == 0
    end

    test "turns left to face south", %{robot: robot} do
      robot = robot |> Robot.turn_left
      assert robot.f == :south
    end

    test "turns right to face north", %{robot: robot} do
      robot = robot |> Robot.turn_right
      assert robot.f == :north
    end
  end

  describe "when the robot is facing north, and it has moved forward a space" do
    setup do: {:ok, %{robot: ToyRobot.Robot.new(0, 1, :north)}}
    test "turns right to face east", %{robot: robot} do
      robot = robot |> Robot.turn_right()
      assert robot.f == :east
      assert robot.y == 1
    end
  end
end
