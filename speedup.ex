defmodule Benchmark do
  def calcular_speedup(tiempo1, tiempo2), do: tiempo2 / tiempo1

  def determinar_tiempo_ejecucion({modulo, funcion, argumentos}) do
    tiempo_inicial = System.monotonic_time()
    apply(modulo, funcion, argumentos)
    tiempo_final = System.monotonic_time()

    duracion =
      System.convert_time_unit(
        tiempo_final - tiempo_inicial,
        :native, :microsecond
      )

    duracion
  end

  def generar_mensaje(tiempo1, tiempo2) do
    speedup = calcular_speedup(tiempo1, tiempo2) |> Float.round(2)

    "Tiempos: #{tiempo1} y #{tiempo2} microsegundos, " <>
    "el primer algoritmo es #{speedup} veces más rápido que el segundo."
  end
end
