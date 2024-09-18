defmodule Mensaje do
  def main do
    "Bienvenidos a la empresa Once Ltda"
    |> mostrar_mensaje()
  end

  defp mostrar_mensaje(mensaje) do
    mensaje
    |> IO.puts()
  end
end


Mensaje.main()
