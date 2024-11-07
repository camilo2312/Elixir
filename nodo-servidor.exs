defmodule NodoServidor do
  @nombre_servicio_local :nodo_servidor

  def main() do
    Util.mostrar_mensaje("PROCESO SECUNDARIO")

    @nombre_servicio_local
    |> registrar_servicio()

    activar_servicio()
  end

  defp registrar_servicio(nombre_servicio_local),
    do: Process.register(self(), nombre_servicio_local)

  defp activar_servicio() do
    receive do
      {productor, mensaje} ->
        respuesta = procesar_mensaje(mensaje)
        send(productor, respuesta)
        activar_servicio()
    end
  end

  defp procesar_mensaje(:fin), do: :fin

  defp procesar_mensaje({:mayusculas, msg}), do: String.upcase(msg)

  defp procesar_mensaje({:minusculas, msg}), do: String.downcase(msg)

  defp procesar_mensaje({funcion, msg}) when is_function(funcion, 1), do: funcion.(msg)

  defp procesar_mensaje(mensaje), do: "El mensaje \"#{mensaje}\" es desconocido"
end

NodoServidor.main()
