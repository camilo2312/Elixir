defmodule DescuentoCedula do
  @anio_fundacion 1991

  def main do
    "Ingrese su número de cédula: "
    |> Util.ingresar(:entero)
    |> generar_mensaje(@anio_fundacion)
    |> Util.mostrar_mensaje()
  end

  # Version 1
  # defp generar_mensaje(cedula, anio) do
  #   if rem(cedula, anio) == 0 do
  #     "Recibe el descuento"
  #   else
  #     "No recibe el descuento"
  #   end
  # end

  # Version 2
  defp generar_mensaje(cedula, anio) when rem(cedula, anio) == 0, do: "Recibe el descuento"
  defp generar_mensaje(_,_), do: "No recibe descuento"
end

DescuentoCedula.main()
