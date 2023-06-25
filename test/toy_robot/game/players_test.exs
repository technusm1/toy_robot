defmodule ToyRobot.Game.PlayersTest do
  alias ToyRobot.Game.Players
  alias ToyRobot.Table
  use ExUnit.Case, async: true

  describe "available positions" do
    setup do
      table = %Table{north_boundary: 1, east_boundary: 1}
      {:ok, table: table}
    end

    test "does not include the occupied positions", %{table: table} do
      occupied_positions = [%{x: 0, y: 0}]
      available_positions = Players.available_positions(occupied_positions, table)
      assert occupied_positions not in available_positions
    end
  end

  describe "change_position_if_occupied" do
    setup do
      table = %Table{north_boundary: 1, east_boundary: 1}
      {:ok, table: table}
    end

    test "changes position if it is occupied", %{table: table} do
      occupied_positions = [%{x: 0, y: 0}]
      original_position = %{x: 0, y: 0, f: :north}
      new_position = Players.change_position_if_occupied(occupied_positions, table, original_position)
      assert new_position != original_position
      assert new_position.f == original_position.f
    end

    test "does not change position if it is not occupied", %{table: table} do
      occupied_positions = []
      original_position = %{x: 0, y: 0, f: :north}
      new_position = Players.change_position_if_occupied(occupied_positions, table, original_position)
      assert new_position == original_position
    end
  end
end
