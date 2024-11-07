defmodule NodoServidor3 do
  @nombre_servicio_global :nodo_funcion

  def iniciar_servicio() do
    Util.mostrar_mensaje("SERVIDOR 3 - Servidor de Función")
    registrar_servicio(@nombre_servicio_global)
    esperar_mensajes()
    deregistrar_servicio(@nombre_servicio_global)
  end

  defp registrar_servicio(nombre_servicio_global) do
    :global.register_name(nombre_servicio_global, self())
    :global.sync()
  end

  defp deregistrar_servicio(nombre_servicio_global) do
    :global.unregister_name(nombre_servicio_global)
  end

  defp esperar_mensajes() do
    receive do
      {_, :fin} ->
        Util.mostrar_mensaje("Desconectando servicio...")
        :ok
      {productor, mensaje} ->
        mensaje
        |> procesar_mensaje()
        |> send_respuesta(productor)

        esperar_mensajes()
    end
  end

  defp procesar_mensaje(:fin), do: :fin
  defp procesar_mensaje({funcion, msg}) when is_function(funcion, 1), do: funcion.(msg)
  defp procesar_mensaje(mensaje), do: "el mensaje \"#{mensaje}\" es desconocido"

  defp send_respuesta(respuesta, productor) do
    send(productor, respuesta)
  end
end

NodoServidor3.iniciar_servicio()
