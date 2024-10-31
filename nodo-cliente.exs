defmodule NodoCliente do
  @nombre_servicio_local :nodo_cliente
  @servicio_local {@nombre_servicio_local, :nodocliente@localhost}

  @nodo_remoto :nodoservidor@localhost
  @servicio_remoto {:nodo_servidor, @nodo_remoto}
end
