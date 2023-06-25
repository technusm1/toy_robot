defmodule ToyRobot.Game.PlayerTest do
  alias ToyRobot.Game.Player
  alias ToyRobot.{Robot, Table}
  use ExUnit.Case, async: true

  def build_table, do: %Table{ north_boundary: 4, east_boundary: 4 }

  describe "init" do
    setup do
      registry_id = :player_init_test
      Registry.start_link(keys: :unique, name: registry_id)
      {:ok, registry_id: registry_id}
    end

    test "maintains the original position", %{registry_id: registry_id} do
      position = %{x: 0, y: 0, f: :north}
      {:ok, %{robot: robot}} = Player.init([registry_id: registry_id, table: build_table(), robot: position, name: Player.process_name(registry_id, "Joanne")])
      assert robot.f == :north
      assert robot.x == 0
      assert robot.y == 0
    end
  end

  describe "init with another player registered" do
    setup do
      registry_id = :player_init_test
      Registry.start_link(keys: :unique, name: registry_id)
      table = build_table()
      Player.start_link(registry_id: registry_id, table: table, robot: %{x: 0, y: 0, f: :west}, name: "Joanna")
      {:ok, registry_id: registry_id, table: table}
    end

    test "picks a random position on the board", %{registry_id: registry_id, table: table} do
      position = %{x: 0, y: 0, f: :north}
      {:ok, %{robot: robot}} = Player.init(
        [registry_id: registry_id, table: table, robot: position, name: Player.process_name(registry_id, "Bobbie")]
      )
      refute match?(%{x: 0, y: 0}, robot)
      assert robot.f == :north
    end
  end

  describe "report" do
    setup do
      registry_id = "player-test-#{UUID.uuid4()}" |> String.to_atom
      Registry.start_link(keys: :unique, name: registry_id)
      starting_position = %Robot{x: 0, y: 0, f: :north}
      {:ok, player} = Player.start_link([registry_id: registry_id, table: build_table(), robot: starting_position, name: "dummy"])
      %{registry_id: registry_id, player: player}
    end

    test "shows the current position of the robot", %{player: player} do
      assert Player.report(player) == %Robot{x: 0, y: 0, f: :north}
    end
  end

  describe "move" do
    setup do
      registry_id = "player-test-#{UUID.uuid4()}" |> String.to_atom
      Registry.start_link(keys: :unique, name: registry_id)
      starting_position = %Robot{x: 0, y: 0, f: :north}
      {:ok, player} = Player.start_link([registry_id: registry_id, table: build_table(), robot: starting_position, name: "dummy"])
      %{registry_id: registry_id, player: player}
    end

    test "moves the robot forward one space", %{player: player} do
      :ok = Player.move(player)
      assert Player.report(player) == %Robot{x: 0, y: 1, f: :north}
    end
  end
end
