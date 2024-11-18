defmodule Calculadora do
  @servicio_remoto :calculadora_servidor@localhost

  def main() do
    [a, b] = obtener_entradas(System.argv())
    suma = sumar(a, b)
    mensaje = generar_mensaje(a, b, suma)
    Util.mostrar_mensaje(mensaje)
  end

  defp obtener_entradas(entradas) do
    case Enum.map(entradas, &String.to_integer/1) do
      [a, b] -> [a, b]
      _ -> raise "Por favor, introduce dos números como argumentos."
    end
  end

  def generar_mensaje(_, _, {:badrpc, _}),
    do: "Hubo un error al invocar el procedimiento remoto"

  def generar_mensaje(a, b, suma) do
    "La suma de #{a} y #{b} es: #{suma}"
  end

  def sumar(a, b) do
    :rpc.call(@servicio_remoto, __MODULE__, :sumar, [a, b])
  end
end

Calculadora.main()
