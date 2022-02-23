defmodule Prueba.PageHandler do

  def get_base_salary(map) do
    map
      |> Map.get(:sueldo)

  end

end
