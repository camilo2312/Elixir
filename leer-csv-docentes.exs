defmodule LeerCsvDocentes do
  def main do
    "Docentes_Uniquindio_20241002.csv"
    |> CSVData.leer_csv(&Docente.convertir_cadena_docente/1)
    |> filtrar_datos_docentes()
    |> CSVData.generar_mensaje(&generar_mensaje/1)
    |> IO.puts()
  end

  defp filtrar_datos_docentes(datos) do
    datos
    |> Enum.filter(fn (docente) -> docente.formacion == "MAESTRIA" and docente.vinculacion == "PLANTA" end)
  end

  def generar_mensaje(docente) do
    "Periodo: #{docente.periodo}," <>
    "Facultad: #{docente.facultad}," <>
    "Programa: #{docente.programa}," <>
    "Genero: #{docente.genero}," <>
    "Formacion: #{docente.formacion}," <>
    "Vinculacion: #{docente.vinculacion}," <>
    "Dedicacion: #{docente.dedicacion}," <>
    "Cargo: #{docente.cargo}," <>
    "Categoria: #{docente.categoria}\n"
  end
end

LeerCsvDocentes.main()
