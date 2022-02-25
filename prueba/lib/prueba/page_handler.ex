defmodule Prueba.PageHandler do
  @moduledoc """
    The module is used to obtain the salary of the players of "Resuelve FC"
  """

  @doc """
  Calculates the sum of the values
  Returns goals value :: int
  ## Parameters
    - team_goal_data: List of maps, contains value as key
  ## Example
    iex> total_team_goals( [%{..., value: 10, ...}, %{..., value: 8, ...}...])

  """
  def total_team_goals(team_goal_data) do
    team_goal_data
    |> Enum.map(fn f -> f.value end)
    |> Enum.sum
  end

  @doc """
  Calculates the sum of the "goles"

  Returns goals value :: int
    ##Parameters
     - individual_goal_data: List of maps, contains "goles" as key
    ## Example
        iex> total_individual_goals([%{..., "goles":19}, %{...,"goles":19}, ...])

  """
  def total_individual_goals(individual_goal_data) do
    individual_goal_data
    |> Enum.map(fn f -> f["goles"] end)
    |> Enum.sum
  end
  @doc """
  Return value where map contains level parameter
    Returns goals value by level :: int
    ## Parameters
    - level: the level that serves as a key to search on the map
    - data: map where to search
    ## Example
      get_level_value(level,  [%{..., level: "A", value: 10, ...}, %{..., level: "B", value: 8, ...}...])

  """
  def get_level_value(level, data) do
    data
    |> Enum.find(fn m -> m.level == level end)
    |> case do
      nil ->
        IO.puts("No level found, adding 0")
        0
      any -> any.value
    end
  end

  @doc """
    Returns a list of maps adding the value "sueldo completo"
    :: List
    ## Parameters
    - json_parced: list of maps to modify, coming from a json decode
    - resuelveFC_map: map list containing "nivel" and "goles" information as a key
    ## Example
      get_level_value([%{..., "salario_completo": nil, goles: 10, ...}, %{...,"salario_completo": nil, level: "B", goles: 8, ...}...],
      [%{..., level: "A", value: 10, ...}, %{..., level: "B", value: 8, ...}...])

  """
  def calculate_total_salary(json_parced, resuelveFC_map) do
    total_team_goal = total_team_goals(resuelveFC_map)
    total_individual_goal = total_individual_goals(json_parced["jugadores"])
    json_parced["jugadores"]
      |> Enum.map(fn f -> f
      |> Map.put("sueldo_completo",
      (
        (((f["goles"] / (f["nivel"] |> get_level_value(resuelveFC_map)) +
        (total_individual_goal/total_team_goal)) / 2 ) * f["bono"]  )
          ) + f["sueldo"] )

      |> Map.put("goles_minimos", f["nivel"] |> get_level_value(resuelveFC_map) )

      end)

  end

  def check_form(json_decode) do
    val = json_decode |> length()
    json_decode
      |> Enum.filter(fn f -> !is_nil(f["level"]) and !is_nil(f["value"]) end)
      |> case do
        {:error, _any} -> false
        [] -> false

        data -> (data |> length() ) == val

      end
  end

  def check_form_principal(json_decode) do
    val = json_decode |> length()
    json_decode
      |> Enum.filter(fn f -> !is_nil(f["nivel"]) and !is_nil(f["goles"])
        and !is_nil(f["sueldo"]) and !is_nil(f["bono"])
        end)
      |> case do
        {:error, _any} -> false
        [] -> false
        data -> (data |> length() ) == val
      end
  end

  def keys_to_atoms(string_key_map) when is_map(string_key_map) do
    for {key, val} <- string_key_map,
      into: %{}, do: {String.to_atom(key),
      keys_to_atoms(val)}
  end

  def keys_to_atoms(string_key_list) when is_list(string_key_list) do
    string_key_list
    |> Enum.map(&keys_to_atoms/1)
  end

  def keys_to_atoms(value), do: value

end
