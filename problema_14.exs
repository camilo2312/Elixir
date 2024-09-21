defmodule Estructura do
  def main do
    "Ingrese los datos del cliente: "
    |> Cliente.ingresar()
    |> generar_mensaje()
    |> Util.mostrar_mensaje()
  end

  defp generar_mensaje(cliente) do
    altura = cliente.altura |> Float.round(2)
    "Hola #{cliente.nombre}, tú edad es de #{cliente.edad} años y " <>
    "tienes una altura de #{altura}\n"
  end
end

Estructura.main()
