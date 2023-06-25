defmodule ToyRobot.Game.GameTest do
  alias ToyRobot.{Game, Robot}
  use ExUnit.Case

  setup do
    {:ok, game} = Game.start(north_boundary: 4, east_boundary: 4)
    {:ok, %{game: game}}
  end

  test "can place a player", %{game: game} do
    :ok = Game.place(game, %Robot{x: 0, y: 0, f: :north}, "Rosie")
    assert Game.player_count(game) == 1
  end

  test "cannot place a robot out of bounds", %{game: game} do
    assert Game.place(game, %Robot{x: 10, y: 10, f: :north}, "Eve") ==  {:error, :out_of_bounds}
  end

  test "can not place a robot in the same space as another robot", %{game: game} do
    starting_position = %Robot{x: 0, y: 0, f: :north}
    :ok = Game.place(game, starting_position, "Wall-E")
    assert Game.place(game, starting_position, "Robby") == {:error, :occupied}
  end

  test "cannot move a robot onto another robot's square", %{game: game} do
    :ok = Game.place(game, %Robot{x: 0, y: 0, f: :north}, "Marvin")
    :ok = Game.place(game, %Robot{x: 0, y: 1, f: :south}, "Chappin")
    assert Game.move(game, "Chappin") == {:error, :occupied}
  end

  test "can move onto an unoccupied square", %{game: game} do
    :ok = Game.place(game, %Robot{x: 2, y: 0, f: :east}, "John")
    :ok = Game.place(game, %Robot{x: 2, y: 1, f: :south}, "Jane")
    assert Game.move(game, "John") == :ok
  end

  describe "respawning" do
    test "davros does not respawn on (1, 1)", %{game: game} do
      izzy_origin = %{x: 1, y: 0, f: :north}
      :ok = Game.place(game, izzy_origin, "Izzy")
      davros_origin = %{x: 1, y: 1, f: :west}
      :ok = Game.place(game, davros_origin, "Davros")

      :ok = Game.move(game, "Davros")
      :ok = Game.move(game, "Izzy")
      :ok = Game.move(game, "Davros")
      :timer.sleep(100)
      refute match?(%{x: 1, y: 1}, Game.report(game, "Davros"))
    end
  end
end
