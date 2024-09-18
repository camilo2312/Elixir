defmodule GranjaConejos do
  def main do
    semana = "Ingrese el número de la semana: "
    |> Util.ingresar(:entero)
    fibo = fibonacci(semana)
    generar_mensaje(semana, fibo)
    |> Util.mostrar_mensaje()
  end

  def fibonacci(0), do: 0
  def fibonacci(1), do: 1
  def fibonacci(n) when n > 1 do
    fibonacci(n - 1) + fibonacci(n - 2)
  end

  def generar_mensaje(semana, fibo) do
    "En la semana #{semana}, hay #{fibo} parejas de conejos."
  end
end

GranjaConejos.main()
