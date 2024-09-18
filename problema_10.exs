defmodule Circular do
  def main do
    "Ingrese la cantidad de personas: "
    |> Util.ingresar(:entero)
    |> Util.calcular_permutaciones_circular()
    |> generar_mensaje()
    |> Util.mostrar_mensaje()
  end

  defp generar_mensaje(resultado) do
    "La cantidad de formas que se pueden sentar a los clientes en una mesa redonda es de: #{resultado}"
  end
end

Circular.main()
