defmodule NodoCliente do
  @servicio_mayusculas :nodo_mayusculas
  @servicio_minusculas :nodo_minusculas
  @servicio_funcion :nodo_funcion

  @cluster [:nodoservidor1@localhost,
            :nodoservidor2@localhost,
            :nodoservidor3@localhost]

  def main() do
    Util.mostrar_mensaje("Proceso principal - Cliente")

    conectar_nodos(@cluster)
    enviar_mensajes()
    esperar_respuestas(0)
  end

  defp conectar_nodos(cluster) do
    Enum.each(cluster, &Node.connect/1)
    :global.sync()
  end

  defp obtener_servicio(nombre_servicio),
    do: :global.whereis_name(nombre_servicio)

  defp enviar_mensajes() do
    mensajes = [
      {{:mayusculas, "Juan"}, @servicio_mayusculas},
      {{:mayusculas, "Ana"}, @servicio_mayusculas},
      {{:minusculas, "Diana"}, @servicio_minusculas},
      {{&String.reverse/1, "Julian"}, @servicio_funcion},
      {"Uniquindio", @servicio_mayusculas}
    ]

    Enum.each(mensajes,
      fn {mensaje, servicio} -> enviar_mensaje(mensaje, servicio) end)

    finalizar_servicios()
  end

  defp enviar_mensaje(mensaje, servicio) do
    case obtener_servicio(servicio) do
      :undefined ->
        IO.puts("No se encontró el servicio #{servicio}")

      pid ->
        send(pid, {self(), mensaje})
    end
  end

  defp finalizar_servicios() do
    [:fin, :fin, :fin]
    |> Enum.zip([@servicio_mayusculas,
                 @servicio_minusculas,
                 @servicio_funcion])
    |> Enum.each(fn {fin, servicio} -> enviar_mensaje(fin, servicio) end)
  end

  defp esperar_respuestas(3),
    do: :ok

  defp esperar_respuestas(i) do
    receive do
      :fin ->
        esperar_respuestas(i + 1)

      respuesta ->
        Util.mostrar_mensaje("\t -> \"#{respuesta}")
        esperar_respuestas(i)
    end
  end
end

NodoCliente.main()
