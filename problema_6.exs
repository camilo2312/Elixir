defmodule Antiguedad do
  def main do
    "Ingrese los años de antiguedad: "
    |> Util.ingresar(:entero)
    |> generar_mensaje()
    |> Util.mostrar_mensaje()
  end

  # Version 1
  # defp generar_mensaje(antiguedad) when (antiguedad >= 1 and antiguedad <= 2), do: "Descuento del 10%"
  # defp generar_mensaje(antiguedad) when (antiguedad >= 3 and antiguedad <= 6), do: "Descuento del 14%"
  # defp generar_mensaje(antiguedad) when (antiguedad > 6), do: "Descuento del 17%"
  # defp generar_mensaje(_), do: "No recibe descuento"

  # Version 2
  defp generar_mensaje(antiguedad) do
    cond do
      antiguedad < 1 -> "0.0"
      antiguedad <= 2 -> "0.10"
      antiguedad <= 6 -> "0.14"
      true -> "0.17"
    end
  end
end

Antiguedad.main()
