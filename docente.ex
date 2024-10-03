defmodule Docente do
  defstruct periodo: "", facultad: "", programa: "", genero: "", formacion: "", vinculacion: "", dedicacion: "", cargo: "", categoria: ""

  def crear(periodo, facultad, programa, genero, formacion, vinculacion, dedicacion, cargo, categoria) do
    %Docente{periodo: periodo, facultad: facultad, programa: programa, genero: genero, formacion: formacion, vinculacion: vinculacion, dedicacion: dedicacion, cargo: cargo, categoria: categoria}
  end

  def convertir_cadena_docente(cadena) do
    [periodo, facultad, programa, genero, formacion, vinculacion, dedicacion, cargo, categoria] =
      cadena
      |> String.split(",")
      |> Enum.map(&String.trim/1)

      Docente.crear(periodo, facultad, programa, genero, formacion, vinculacion, dedicacion, cargo, categoria)
  end
end
