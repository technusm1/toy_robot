defmodule ToyRobot.CommandRunner do
  alias ToyRobot.SimulationDriver
  alias ToyRobot.Table

  def run([{:place, placement} | rest]) do
    table = %Table{north_boundary: 4, east_boundary: 4}
    case SimulationDriver.place(table, placement) do
      {:ok, simulation} -> run(rest, simulation)
      {:error, :invalid_placement} -> run(rest)
    end
  end

  def run([]), do: nil # Empty case
  def run([_command | rest]), do: run(rest) # Consumes everything until the first valid place command is encountered

  defp run([:move | rest], simulation) do
    case simulation |> SimulationDriver.move do
      {:ok, new_simulation} -> run(rest, new_simulation)
      {:error, :at_table_boundary} -> run(rest, simulation)
    end
  end

  defp run([:turn_left | rest], simulation) do
    {:ok, simulation} = simulation |> SimulationDriver.turn_left
    run(rest, simulation)
  end

  defp run([:turn_right | rest], simulation) do
    {:ok, simulation} = simulation |> SimulationDriver.turn_right
    run(rest, simulation)
  end

  defp run([:report | rest], simulation) do
    %{x: x, y: y, f: f} = SimulationDriver.report(simulation)
    facing = f |> Atom.to_string |> String.upcase
    IO.puts("The robot is at (#{x}, #{y}) and is facing #{facing}")
    run(rest, simulation)
  end

  defp run([{:invalid, _} | rest], simulation) do
    run(rest, simulation)
  end

  defp run([], simulation) do
    simulation
  end
end
