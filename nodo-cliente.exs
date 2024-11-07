defmodule NodoCliente do
  @nombre_servicio_local :nodo_cliente
  @servicio_local {@nombre_servicio_local, :nodocliente@localhost}

  @nodo_remoto :nodoservidor@localhost
  @servicio_remoto {:nodo_servidor, @nodo_remoto}

  def main() do
    Util.mostrar_mensaje("PROCESO PRINCIPAL")

    @nombre_servicio_local
    |> registrar_servicio()

    @nodo_remoto
    |> verificar_conexion()
    |> activar_productor()
  end

  def registrar_servicio(nombre_servicio_local),
    do: Process.register(self(), nombre_servicio_local)

  defp verificar_conexion(nodo_remoto),
    do: Node.connect(nodo_remoto)

  defp activar_productor(:true) do
    producir_elementos()
    recibir_respuestas()
  end

  defp activar_productor(:false),
    do: Util.mostrar_error("No se pudo conectar con el nodo servidor")

  defp producir_elementos() do
    mensajes = [
      {:mayusculas, "Juan"},
      {:mayusculas, "Ana"},
      {:minusculas, "Diana"},
      {&String.reverse/1, "Julian"},
      "Uniquindio",
      :fin
    ]

    Enum.each(mensajes, &enviar_mensaje(&1))
  end

  defp enviar_mensaje(mensaje) do
    send(@servicio_remoto, {@servicio_local, mensaje})
  end

  defp recibir_respuestas() do
    receive do
      :fin ->
        :ok

      respuesta ->
        Util.mostrar_mensaje("\t -> \"#{respuesta}")
        recibir_respuestas()
    end
  end
end

NodoCliente.main()
