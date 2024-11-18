defmodule CNFReader do
  @moduledoc """
  Este módulo proporciona funciones para leer, procesar, validar y analizar
  archivos en formato CNF (Conjunctive Normal Form).
  """

  @typedoc """
  Estructura para representar el contenido de un archivo CNF.
  - `variables`: Número total de variables declaradas.
  - `clauses_count`: Número total de cláusulas declaradas.
  - `clauses`: Lista de cláusulas, cada una representada como una lista de literales.
  """
  defstruct variables: 0, clauses_count: 0, clauses: []

  @doc """
  Punto de entrada principal. Procesa un archivo CNF y muestra las asignaciones válidas.
  """
  def main do
    "uf20-01000.cnf"
    |> read_cnf_file()
    |> measure_get_valid_values()
    |> generate_message()
    |> IO.puts()
  end

  @doc """
  Mide el tiempo de ejecución de `get_valid_values/1`.

  ## Parámetros
  - `{:ok, cnf}`: Una tupla que contiene un archivo CNF procesado.

  ## Retorno
  - Devuelve el resultado de `get_valid_values/1`.
  """
  defp measure_get_valid_values({:ok, cnf}) do
    {time, result} = :timer.tc(fn -> get_valid_values({:ok, cnf}) end)
    IO.puts("Tiempo de ejecución de get_valid_values: #{time / 1_000_000} segundos")
    result
  end

  @doc """
  Lee y procesa un archivo CNF.

  ## Parámetros
  - `file_path`: Ruta del archivo CNF a leer.

  ## Retorno
  - `{:ok, %CNFReader{}}` si el archivo se procesa correctamente.
  - `{:error, reason}` si ocurre un error al leer el archivo.
  """
  def read_cnf_file(file_path) do
    case File.read(file_path) do
      {:ok, content} ->
        content
        |> String.split("\n")
        |> Enum.reduce(%CNFReader{}, &process_line/2)
        |> validate_cnf()

      {:error, reason} ->
        {:error, "Error al leer el archivo: #{reason}"}
    end
  end

  @doc """
  Procesa una línea del archivo CNF.

  ## Parámetros
  - `line`: Línea del archivo CNF.
  - `acc`: Acumulador que contiene la estructura `%CNFReader{}`.

  ## Retorno
  - Una estructura `%CNFReader{}` actualizada.
  """
  defp process_line(line, acc) do
    cond do
      String.starts_with?(line, "c") -> acc
      String.starts_with?(line, "p") -> parse_problem_line(line, acc)
      String.starts_with?(line, "%") -> acc
      String.starts_with?(line, "0") -> acc
      String.trim(line) == "" -> acc
      true -> parse_clause(line, acc)
    end
  end

  @doc """
  Procesa la línea del problema (línea que comienza con `p cnf`).

  ## Parámetros
  - `line`: Línea del problema en el archivo CNF.
  - `acc`: Acumulador de tipo `%CNFReader{}`.

  ## Retorno
  - Una estructura `%CNFReader{}` actualizada con el número de variables y cláusulas.
  """
  defp parse_problem_line(line, acc) do
    case String.split(line) do
      ["p", "cnf", vars, clauses] ->
        %{acc | variables: String.to_integer(vars), clauses_count: String.to_integer(clauses)}
      _ ->
        IO.puts("Línea de problema malformada: #{line}")
        acc
    end
  end

  @doc """
  Procesa una línea que representa una cláusula.

  ## Parámetros
  - `line`: Línea con literales separados por espacios.
  - `acc`: Acumulador de tipo `%CNFReader{}`.

  ## Retorno
  - Una estructura `%CNFReader{}` actualizada con la cláusula agregada.
  """
  defp parse_clause(line, acc) do
    literals =
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> Enum.reject(&(&1 == 0))

    %{acc | clauses: acc.clauses ++ [literals]}
  end

  @doc """
  Valida que el número de cláusulas coincida con lo especificado en la línea del problema.

  ## Parámetros
  - `cnf`: Estructura `%CNFReader{}`.

  ## Retorno
  - `{:ok, cnf}` si el archivo es válido.
  - `{:error, reason}` si no es válido.
  """
  defp validate_cnf(cnf) do
    if cnf.clauses_count == length(cnf.clauses) do
      {:ok, cnf}
    else
      {:error, "El número de cláusulas no coincide con lo especificado en la línea de problema."}
    end
  end

  @doc """
  Genera asignaciones válidas que satisfacen todas las cláusulas.

  ## Parámetros
  - `{:ok, cnf}`: Una tupla con el archivo CNF validado.

  ## Retorno
  - Lista de cadenas binarias que representan asignaciones válidas.
  """
  defp get_valid_values({:ok, cnf}) do
    max_value = trunc(:math.pow(2, cnf.variables)) - 1

    valid_assignments =
      for x <- 0..max_value,
          assignment = integer_to_assignment(x, cnf.variables),
          satisfies_all?(cnf.clauses, assignment),
          do: assignment_to_binary(assignment, cnf.variables)

    valid_assignments
  end

  @doc """
  Convierte un entero en un mapa de asignaciones booleanas.

  ## Parámetros
  - `integer`: Número entero que representa una asignación.
  - `variables`: Número total de variables.

  ## Retorno
  - Mapa de asignaciones `{variable => valor}`.
  """
  defp integer_to_assignment(integer, variables) do
    0..(variables - 1)
    |> Enum.map(fn i ->
      {i + 1, if(Bitwise.band(Bitwise.bsr(integer, i), 1) == 1, do: 1, else: 0)}
    end)
    |> Map.new()
  end

  @doc """
  Convierte un mapa de asignaciones a una representación binaria.

  ## Parámetros
  - `assignment`: Mapa de asignaciones.
  - `variables`: Número total de variables.

  ## Retorno
  - Representación binaria como cadena.
  """
  defp assignment_to_binary(assignment, variables) do
    1..variables
    |> Enum.map(fn i -> Integer.to_string(Map.get(assignment, i, 0)) end)
    |> Enum.join()
  end

  @doc """
  Verifica si una asignación satisface todas las cláusulas.

  ## Parámetros
  - `clauses`: Lista de cláusulas.
  - `assignment`: Mapa de asignaciones.

  ## Retorno
  - `true` si todas las cláusulas son satisfechas, `false` en caso contrario.
  """
  defp satisfies_all?(clauses, assignment) do
    Enum.all?(clauses, fn clause ->
      Enum.any?(clause, fn literal ->
        (literal > 0 and Map.get(assignment, literal, 0) == 1) or
        (literal < 0 and Map.get(assignment, -literal, 0) == 0)
      end)
    end)
  end

  @doc """
  Genera un mensaje formateado con las asignaciones válidas.

  ## Parámetros
  - `list`: Lista de asignaciones válidas.

  ## Retorno
  - Cadena de texto con asignaciones separadas por espacios y líneas nuevas.
  """
  defp generate_message(list) do
    list
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.join("\n")
  end
end

CNFReader.main()
