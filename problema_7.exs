defmodule Contenedor do
  def main do
    "Ingrese la bolsa: "
    |> Util.ingresar(:texto)
    |> generar_mensaje()
    |> Util.mostrar_mensaje()
  end

  # Version 1
  # defp generar_mensaje(tipoContenedor) do
  #   cond do
  #     String.downcase(tipoContenedor) == "plastica" -> "Descuento 2%"
  #     String.downcase(tipoContenedor) == "biodegradable" -> "Descuento 12%"
  #     String.downcase(tipoContenedor) == "reutilizable" -> "Descuento 17%"
  #     true -> "No recibe descuento"
  #   end
  # end

  # Version 2
  # defp generar_mensaje(tipoContenedor) do
  #   case String.downcase(tipoContenedor) do
  #     "plastica" -> "Descuento 2%"
  #     "biodegradable" -> "Descuento 12%"
  #     "reutilizable" -> "Descuento 17%"
  #     _ -> "No recibe descuento"
  #   end
  # end

  # Version 3
  defp generar_mensaje("plastica"), do: "Descuento 2%"
  defp generar_mensaje("biodegradable"), do: "Descuento 12%"
  defp generar_mensaje("reutilizable"), do: "Descuento 17%"
  defp generar_mensaje(_), do: "No recibe descuento"

end

Contenedor.main()
