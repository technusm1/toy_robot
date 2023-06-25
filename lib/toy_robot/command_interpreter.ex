defmodule ToyRobot.CommandInterpreter do
  @doc """
  Interprets commands from a commands list and prepares them for execution.

  ## Examples
      iex> alias ToyRobot.CommandInterpreter
      ToyRobot.CommandInterpreter
      iex> commands = ["PLACE 1,2,NORTH", "MOVE", "LEFT", "RIGHT", "REPORT", "SPIN", "EXTERMINATE", "PLACE 1, 2, NORTH", "mOvE"]
      ["PLACE 1,2,NORTH", "MOVE", "LEFT", "RIGHT", "REPORT", "SPIN", "EXTERMINATE", "PLACE 1, 2, NORTH", "mOvE"]
      iex> commands |> CommandInterpreter.interpret
      [
        {:place, %{x: 1, y: 2, f: :north}},
        :move,
        :turn_left,
        :turn_right,
        :report,
        {:invalid, "SPIN"},
        {:invalid, "EXTERMINATE"},
        {:invalid, "PLACE 1, 2, NORTH"},
        {:invalid, "mOvE"}
      ]
  """
  def interpret(commands_list) do
    commands_list |> Enum.map(&do_interpret/1)
  end

  defp do_interpret(("PLACE" <> _rest) = command) do
    format = ~r/\APLACE (\d+),(\d+),(NORTH|EAST|SOUTH|WEST)\z/
    case Regex.run(format, command) do
      [_command, x, y, f] -> {
        :place,
        %{
          x: String.to_integer(x),
          y: String.to_integer(y),
          f: f |> String.downcase |> String.to_atom
        }
      }
      nil -> {:invalid, command}
    end

  end

  defp do_interpret(command) do
    case command do
      "MOVE" -> :move
      "LEFT" -> :turn_left
      "RIGHT" -> :turn_right
      "REPORT" -> :report
      invalid_command -> {:invalid, invalid_command}
    end
  end
end
