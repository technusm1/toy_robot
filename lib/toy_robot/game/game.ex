defmodule ToyRobot.Game do
  alias ToyRobot.Game.Server

  def start([north_boundary: north_boundary, east_boundary: east_boundary]) do
    Server.start_link([north_boundary: north_boundary, east_boundary: east_boundary])
  end

  def place(game, position, name) do
    # This is to see if the position is within bounds, so no data races should be occuring with valid_position alone.
    # But if we use position_available, a data race can occur if place(game, position, name) is called from multiple processes,
    # i.e. if we try to place multiple players in the game, its possible we get :ok for both valid_position and position_available
    # Eventually, both processes will call :place, which could potentially put multiple players on same coordinates (even though it is serialized).
    with :ok <- game |> valid_position(position),
         :ok <- game |> position_available(position) do
      GenServer.call(game, {:place, position, name})
    else
      error -> error
    end
  end

  def move(game, name) do
    # One guy stands on (0, 1, :east). Other stands on(0, 3, :west)
    # next_position should return (0, 2) for both and that position can be available for both,
    # since move(game, name) is not serialized call.
    next_pos = next_position(game, name)
    game
    |> position_available(next_pos)
    |> case do
      :ok -> GenServer.call(game, {:move, name})
      error -> error
    end
  end

  defp next_position(game, name) do
    GenServer.call(game, {:next_position, name})
  end

  defp position_available(game, position) do
    GenServer.call(game, {:position_available, position})
  end

  defp valid_position(game, position), do: GenServer.call(game, {:valid_position, position})

  def player_count(game) do
    GenServer.call(game, :player_count)
  end

  def report(game, name) do
    GenServer.call(game, {:report, name})
  end
end
