defmodule CNFCalculate do
  @moduledoc """
  Módulo encargado de coordinar la ejecución de cálculos remotos sobre un archivo CNF
  utilizando llamadas a procedimientos remotos (RPC).

  Este módulo toma el nombre de un archivo CNF como entrada, realiza una solicitud remota
  para procesarlo y genera un mensaje con el resultado.
  """

  @servicio_remoto :server_cnf@localhost

  @doc """
  Punto de entrada principal del programa. Obtiene el archivo de entrada desde los argumentos
  de la línea de comandos, realiza el cálculo y muestra el resultado.

  ## Ejemplo de uso
      $ elixir cnf_calculate.exs archivo.cnf
  """
  def main() do
    nombre_archivo = obtener_entradas(System.argv())
    resultado = obtener_resultado(nombre_archivo)
    mensaje = generar_mensaje(nombre_archivo, resultado)
    IO.puts(mensaje)
  end

  @doc """
  Genera un mensaje con el resultado del cálculo o un mensaje de error en caso de fallo.

  ## Parámetros
  - `archivo`: Nombre del archivo procesado.
  - `resultado`: Resultado del cálculo o un error.

  ## Retorno
  - Cadena formateada con el resultado o un mensaje de error.
  """
  def generar_mensaje(_, _, {:badrpc, _}),
    do: "Hubo un error al invocar el procedimiento remoto"

  def generar_mensaje(archivo, resultado) do
    "El resultado para el archivo #{archivo} es: \n#{resultado}"
  end

  @doc """
  Realiza una llamada a procedimiento remoto (RPC) para calcular los resultados del archivo CNF.

  ## Parámetros
  - `archivo`: Nombre del archivo CNF.

  ## Retorno
  - El resultado del cálculo en el nodo remoto o un error si la llamada falla.
  """
  def obtener_resultado(archivo) do
    :rpc.call(@servicio_remoto, __MODULE__, :calcular_resultados, archivo)
  end

  @doc """
  Obtiene el nombre del archivo CNF desde los argumentos de la línea de comandos.

  ## Parámetros
  - `entradas`: Lista de argumentos pasados al programa.

  ## Retorno
  - Una cadena que representa el nombre del archivo CNF.
  """
  defp obtener_entradas(entradas) do
    entradas
  end
end

CNFCalculate.main()
