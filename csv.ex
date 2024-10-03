defmodule CSVData do
  def leer_csv(nombre, parser) do
    nombre
    |> File.stream!()
    |> Stream.drop(1) #ignora los encabezados
    |> Enum.map(parser)
  end

  def generar_mensaje(objeto, parser) do
    objeto
    |> Enum.map(parser)
    |> Enum.join("\n")
  end
end
