defmodule Listado do
  def main do
    valor_inicial =
    "\n Ingrese un valor inicial: "
    |> Util.ingresar(:entero)

    valor_final =
    "\n Ingrese un valor final: "
    |> Util.ingresar(:entero)

    valor_inicial..valor_final
    |> generar_listado()
    |> Util.mostrar_mensaje()

  end

  defp generar_listado(listado_numeracion) do
    listado_numeracion
    |> Enum.map(&("#{&1}.__________________________\n"))
    |> Enum.join()
  end

  # defp generar_listado(valor_inicial, valor_final) do
  #   valor_inicial
  #   |> generar_linea()
  #   |> (&("#{&1}#{generar_listado(valor_inicial + 1, valor_final)}")).()
  # end

  # defp generar_linea(valor), do: "#{valor}._________________________\n"
end

Listado.main()
