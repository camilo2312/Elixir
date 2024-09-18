defmodule Util do
  def mostrar_mensaje(mensaje) do
    System.cmd("python", ["mostrar_dialogo.py", mensaje])
  end

  def mostrar_error(mensaje) do
    IO.puts(:standard_error, mensaje)
  end

  def ingresar(mensaje, parser, tipo_dato) do
    try do
      mensaje
      |> ingresar(:texto)
      |> parser.()
    rescue
      ArgumentError ->
        "Error, se espera que ingrese un error número #{tipo_dato} \n"
        |> mostrar_error()

        mensaje
        |> ingresar(parser, tipo_dato)
    end
  end

  def ingresar(mensaje, :texto) do
    {entrada, 0} = System.cmd("python", ["ingresar_dialogo.py", mensaje])

    entrada
    |> String.trim()
  end

  def ingresar(mensaje, :entero), do: ingresar(mensaje, &String.to_integer/1, :entero)
  def ingresar(mensaje, :real), do: ingresar(mensaje, &String.to_float/1, :real)

  # Calcular permutaciones circulares
  def calcular_permutaciones_circular(cantidad_personas) do
    cantidad_personas - 1
    |> calcular_factorial()
  end

  # Calcular factorial de un número
  def calcular_factorial(0), do: 1
  def calcular_factorial(n), do: n * calcular_factorial(n - 1)
end
