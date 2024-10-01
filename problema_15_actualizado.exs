defmodule Estructuras do
  def main do
    "Ingrese los datos de los clientes: "
    |> Cliente.ingresar(:clientes)
    |> Cliente.escribir_csv("clientes_desde_teclado.csv")
  end

  # defp crear_lista_clientes() do
  #   [
  #     Cliente.crear("Ana", 16, 1.70),
  #     Cliente.crear("Juan", 20, 1.72),
  #     Cliente.crear("Diana", 48, 1.71),
  #     Cliente.crear("Julian", 51, 1.73),
  #     Cliente.crear("Isabella", 6, 1.00),
  #     Cliente.crear("Sara", 8, 1.30)
  #   ]
  # end
end

Estructuras.main()
