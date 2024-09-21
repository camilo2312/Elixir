defmodule GranjaConejos do
  def main do
    semana = "Ingrese el número de la semana: "
    |> Util.ingresar(:entero)
    fibo = fibonacci(semana)
    generar_mensaje(semana, fibo)
    |> Util.mostrar_mensaje()
  end

  defp fibonacci(0, _, _ ), do: 0
  defp fibonacci(1, b, _ ), do: b
  defp fibonacci(n, b, a ) do
    fibonacci(n - 1, b + a, b)
  end

  defp fibonacci(n) do
    fibonacci(n, 1, 0)
  end

  def generar_mensaje(semana, fibo) do
    "En la semana #{semana}, hay #{fibo} parejas de conejos."
  end
end

GranjaConejos.main()
