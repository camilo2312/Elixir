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

  defp verificar_conexio(nodo_remoto),
    do: Node.connect(nodo_remoto)

  defp activar_productor(:true) do
    producir_elementos()
    recibir_respuestas()
  end

  defp activiar_productor(:false),
    do: Util.mostrar_error("No se pudo conectar con el nodo servidor")
end
