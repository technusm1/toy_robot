defmodule ToyRobot.Table do
  defstruct north_boundary: 0, east_boundary: 0

  @doc """
  Determines if a position {x, y} would be within a table's boundaries

  ## Examples
      iex> alias ToyRobot.Table
      ToyRobot.Table
      iex> table = %Table{north_boundary: 4, east_boundary: 4}
      %Table{north_boundary: 4, east_boundary: 4}
      iex> table |> Table.valid_position?(%{x: 4, y: 4})
      true
      iex> table |> Table.valid_position?(%{x: 0, y: 0})
      true
      iex> table |> Table.valid_position?(%{x: 6, y: 0})
      false
  """
  def valid_position?(table, %{x: x, y: y}) when is_struct(table, __MODULE__) do
    table.north_boundary >= y and table.east_boundary >= x and y >= 0 and x >= 0
  end

  @doc """
  Returns all valid positions that are within a table's boundaries.

  ## Examples
      iex> alias ToyRobot.Table
      ToyRobot.Table
      iex> table = %Table{north_boundary: 1, east_boundary: 1}
      %Table{north_boundary: 1, east_boundary: 1}
      iex> table |> Table.valid_positions
      [ %{x: 0, y: 0}, %{x: 0, y: 1}, %{x: 1, y: 0}, %{x: 1, y: 1} ]
  """
  def valid_positions(%__MODULE__{north_boundary: north_boundary, east_boundary: east_boundary}) do
    for x <- 0..east_boundary, y <- 0..north_boundary do
      %{x: x, y: y}
    end
  end
end
