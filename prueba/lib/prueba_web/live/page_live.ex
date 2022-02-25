defmodule PruebaWeb.PageLive do
  use PruebaWeb, :live_view
  alias Prueba.PageHandler
  @moduledoc """
    The module is used to obtain the salary of the players of "Resuelve FC" and handle front end events
  """

  @doc """
  Mount the socket and assign values ​​to the socket :: Socket
  ## Parameters
  -json_in, take the changes in the form as a String
  -json_print, takes the value of the result to show in the html
  -json_in_levels, takes the optional value of goal/bonus as a String
  -resuelveFC_goal, takes the optional value of goal/bonus after being decoded, can also have a default value

  """

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      json_in: "",
      json_print: "",
      json_in_levels: "",
      resuelveFC_goal: individual_goal_data()
    )}
  end

  @doc """
  Receive the update_json event with the text_area_json value as a String, assign it to the json_in value on the socket :: Socket
  ## Parameters
    - update_json, name of the event coming from the form in the html
    - %{"text_area_json" => json}, String from the text area in the html
    - socket, socket mounted
  """

  def handle_event("update_json", %{"text_area_json" => json}, socket) do
    {:noreply, assign(socket, json_in: json)}
  end

  @doc """
  Receive the update_json_levels event with the text_area_json_levels value as a String, assign it to the json_in value on the socket :: Socket
  ## Parameters
    - update_json_levels, name of the event coming from the form in the html
    - %{"text_area_json_levels" => json_team}, String from the text area in the html
    - socket, socket mounted
  """

  def handle_event("update_json_levels", %{"text_area_json_levels" => json_team}, socket) do
    {:noreply, assign(socket, json_in_levels: json_team )}
  end

  @doc """
  Receives the click event change_team coming from the button in html, it returns the mounted socket with the value of the result, if it is correct it is assigned
  to the resolverFC_goal in the socket and a message is displayed in html, otherwise it shows the error :: Socket
  ## Parameters
    -change_team, name of the event coming from the button  in the html
    -socket, socket mounted
  """
  def handle_event("change_team", _params, socket) do
    resuelveFC_goal = socket.assigns.resuelveFC_goal
    json_in_levels = socket.assigns.json_in_levels
      data = json_in_levels
        |> Poison.decode()
        |> case do
          {:ok, data} ->
          val =  (data |> PageHandler.check_form) == true
          new_json = data  |> PageHandler.keys_to_atoms
            {:noreply, assign(socket, json_in_levels: json_in_levels,
              json_print: (if val, do: "Data accepted", else: "wrong keys in json"  ),
              resuelveFC_goal: (if val, do: new_json, else: resuelveFC_goal )
              )}
          {:error, _any} ->  {:noreply, assign(socket, json_in_levels: json_in_levels, json_print: "Json data malformed")}
        end

  end

  @doc """

  It receives the send_json click event from the button in html, it returns the mounted socket with the value of the result,
    if it is correct it is assigned to json_print in the socket and it is shown in the html, otherwise it shows the error :: Socket
  ## Parameters
    -send_json, name of the event coming from the button  in the html
    - socket, socket mounted
  """

  def handle_event("send_json", _params, socket) do
    json = socket.assigns.json_in
    resuelveFC_goal = socket.assigns.resuelveFC_goal
    json
      |> Poison.decode()
        |> case do
          {:ok, data} ->
            val = data["jugadores"] |> PageHandler.check_form_principal()
            val
            |> case do
              true ->
                result = calculate_total_salary(data, resuelveFC_goal)
                |> Enum.map(fn f -> f |> Map.put("sueldo_completo", f["sueldo_completo"] |>  :erlang.float_to_binary(decimals: 2)) end)
                  {:noreply, assign(socket, json_print: %{"jugadores": result } |> Poison.encode! )}
              false ->
                {:noreply, assign(socket, json_print: "wrong keys in json" )}
            end
          {:error, _any} ->
              {:noreply, assign(socket, json_print: "Error: json malformed")}
        end
  end

  @doc """
  Call calculate_total_salary function in PageHandler module :: List
  ## Parameters
    - json_parced, json decoded
    - resuelveFC_map, json decoded or initialized on the socket
  """
  defp calculate_total_salary(json_parced, resuelveFC_map ) do
    json_parced |> PageHandler.calculate_total_salary(resuelveFC_map)
  end

  @doc """
  List with the base values ​​of goal/bonus, it is assigned to the socket when mounting it, it is replaced if the user enters another json in the "change_team" event :: List
  """

  defp individual_goal_data() do
    [
      %{level: "A", value: 5},
      %{level: "B", value: 10},
      %{level: "C", value: 15},
      %{level: "Cuauh", value: 20}
    ]
  end
end
