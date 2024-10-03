defmodule Estructuras do
  # def main do
  #   "clientes.csv"
  #   |> Cliente.leer_csv()
  #   |> filtrar_datos_clientes()
  #   |> Cliente.generar_mensaje_clientes(&generar_mensaje/1)
  #   |> Util.mostrar_mensaje()
  # end

  def main do
    "clientes.csv"
    |> CSVData.leer_csv(&Cliente.convertir_cadena_cliente/1)
    |> filtrar_datos_clientes()
    |> CSVData.generar_mensaje(&generar_mensaje/1)
    |> Util.mostrar_mensaje()
  end

  defp filtrar_datos_clientes(datos) do
    datos
    |> Enum.filter(fn (cliente) -> cliente.edad < 21 end)
  end

  defp generar_mensaje(cliente) do
    altura = cliente.altura |> Float.round(2)
    "Hola #{cliente.nombre}, tú edad es de #{cliente.edad} años y " <>
    "tienes una altura de #{altura}\n"
  end
end

Estructuras.main()
