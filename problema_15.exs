defmodule ListaClientes do
  # def main do
  #   "Ingrese los datos de los clientes: "
  #   |> Cliente.ingresar(:clientes)
  #   |> generar_mensaje_clientes()
  #   |> Util.mostrar_mensaje()
  # end

  def main do
    "Ingrese los datos de los clientes: "
    |> Cliente.ingresar(:clientes)
    |> Cliente.generar_mensaje_clientes(&generar_mensaje/1)
    |> Util.mostrar_mensaje()
  end

  # defp generar_mensaje_clientes(lista_clientes) do
  #   lista_clientes
  #   |> Enum.map(&generar_mensaje/1)
  #   |> Enum.join()
  # end

  defp generar_mensaje(cliente) do
    altura = cliente.altura |> Float.round(2)
    "Hola #{cliente.nombre}, tú edad es de #{cliente.edad} años y " <>
    "tienes una altura de #{altura}\n"
  end
end

ListaClientes.main()
