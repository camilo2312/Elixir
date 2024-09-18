defmodule ParImpar do
  # def main do
  #   "Ingrese un número"
  #   |> Util.ingresar(:entero)
  #   |> determinar_par?()
  #   |> generar_mensaje()
  #   |> Util.mostrar_mensaje()
  # end

  # def main do
  #   valor = 200_000

  #   algoritmo1 = {ParImpar, :determinar_par3?, [valor]}
  #   algoritmo2 = {ParImpar, :determinar_par4?, [valor]}

  #   duracion1 = Benchmark.determinar_tiempo_ejecucion(algoritmo1)
  #   duracion2 = Benchmark.determinar_tiempo_ejecucion(algoritmo2)

  #   Benchmark.generar_mensaje(duracion1, duracion2)
  #   |> Util.mostrar_mensaje()

  # end

  def main do
    generar_csv()
  end

  def generar_csv() do
    datos_prueba = [10_000, 100_000, 1_000_000, 10_000_000, 100_000_000]
    archivo_csv = "tiempos.csv"

    File.write!(archivo_csv, "Numero, Tiempo1, Tiempo2, Tiempo3, Tiempo 4\n")

    Enum.each(datos_prueba, fn valor ->
      Enum.each(1..5, fn _ ->
        datos = generar_datos(valor)

        linea_csv = "#{valor},#{Enum.join(datos, "; ")}\n"

        File.write!(archivo_csv, linea_csv, [:append])
      end)
    end)

    IO.puts("Archivo CSV generado con éxito en #{archivo_csv}")
  end

  defp generar_datos(valor) do
    algoritmo1 = {ParImpar, :determinar_par1?, [valor]}
    algoritmo2 = {ParImpar, :determinar_par2?, [valor]}
    algoritmo3 = {ParImpar, :determinar_par3?, [valor]}
    algoritmo4 = {ParImpar, :determinar_par4?, [valor]}

    duracion1 = Benchmark.determinar_tiempo_ejecucion(algoritmo1)
    duracion2 = Benchmark.determinar_tiempo_ejecucion(algoritmo2)
    duracion3 = Benchmark.determinar_tiempo_ejecucion(algoritmo3)
    duracion4 = Benchmark.determinar_tiempo_ejecucion(algoritmo4)

    [duracion1, duracion2, duracion3, duracion4]
  end

  #Version 1
  def determinar_par1?(0), do: true
  def determinar_par1?(1), do: false
  def determinar_par1?(n), do: determinar_par1?(n - 2)

  # Version 2
  def determinar_par2?(n), do: determinar_par2?(0, n)

  def determinar_par2?(m, n) when m * 2 == n, do: true
  def determinar_par2?(m, n) when m * 2 > n, do: false
  def determinar_par2?(m, n), do: determinar_par2?(m + 1, n)

  # Version 3
  def determinar_par3?(0), do: :true
  def determinar_par3?(n), do: determinar_impar3?(n - 1)

  def determinar_impar3?(0), do: :false
  def determinar_impar3?(n), do: determinar_par3?(n - 1)

  # Version 4
  def determinar_par4?(n) when rem(n, 2) == 0, do: true
  def determinar_par4?(_), do: false


  # defp generar_mensaje(true), do: "Es par"
  # defp generar_mensaje(false), do: "Es impar"

end

ParImpar.main()
