defmodule CNFReaderV2 do
  @moduledoc """
  Este módulo proporciona una versión mejorada para procesar, validar y analizar archivos en formato CNF (Conjunctive Normal Form).
  Incluye optimizaciones mediante tareas asincrónicas para calcular asignaciones válidas.
  """

  @typedoc """
  Estructura para representar un archivo CNF:
  - `variables`: Número total de variables.
  - `clauses_count`: Número total de cláusulas.
  - `clauses`: Lista de cláusulas, cada una representada como una lista de literales.
  """
  defstruct variables: 0, clauses_count: 0, clauses: []

  @doc """
  Punto de entrada principal. Procesa un archivo CNF y genera las asignaciones válidas.

  Este flujo incluye la lectura del archivo, la validación de su contenido, el cálculo
  de las asignaciones válidas y la generación de un mensaje formateado.
  """
  def main do
    "uf20-01000.cnf"
    |> read_cnf_file()
    |> measure_get_valid_values()
    |> generate_message()
    |> IO.puts()
  end

  @doc """
  Lee y procesa un archivo CNF.

  ## Parámetros
  - `file_path`: Ruta del archivo CNF.

  ## Retorno
  - `{:ok, %CNFReaderV2{}}` si el archivo es válido.
  - `{:error, reason}` si ocurre algún problema.
  """
  def read_cnf_file(file_path) do
    case File.read(file_path) do
      {:ok, content} ->
        content
        |> String.split("\n")
        |> Enum.reduce(%CNFReaderV2{}, &process_line/2)
        |> validate_cnf()

      {:error, reason} ->
        {:error, "Error al leer el archivo: #{reason}"}
    end
  end

  @doc """
  Mide el tiempo de ejecución de `get_valid_values/1`.

  ## Parámetros
  - `{:ok, cnf}`: Tupla con el archivo CNF procesado.

  ## Retorno
  - Lista de asignaciones válidas.
  """
  defp measure_get_valid_values({:ok, cnf}) do
    {time, result} = :timer.tc(fn -> get_valid_values({:ok, cnf}) end)
    IO.puts("Tiempo de ejecución de get_valid_values: #{time / 1_000_000} segundos")
    result
  end

  @doc """
  Procesa una línea del archivo CNF.

  ## Parámetros
  - `line`: Línea del archivo CNF.
  - `acc`: Acumulador con la estructura `%CNFReaderV2{}`.

  ## Retorno
  - Estructura actualizada con los datos procesados de la línea.
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
  Procesa la línea del problema (que comienza con `p cnf`).

  ## Parámetros
  - `line`: Línea del problema.
  - `acc`: Acumulador de tipo `%CNFReaderV2{}`.

  ## Retorno
  - Estructura actualizada con las variables y el conteo de cláusulas.
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
  Procesa una línea de cláusula.

  ## Parámetros
  - `line`: Línea que contiene una cláusula en formato CNF.
  - `acc`: Acumulador de tipo `%CNFReaderV2{}`.

  ## Retorno
  - Estructura actualizada con la cláusula agregada.
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
  Valida el contenido del archivo CNF.

  ## Parámetros
  - `cnf`: Estructura `%CNFReaderV2{}`.

  ## Retorno
  - `{:ok, cnf}` si la validación es exitosa.
  - `{:error, reason}` si la validación falla.
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

  Utiliza tareas asincrónicas para calcular las asignaciones en paralelo.

  ## Parámetros
  - `{:ok, cnf}`: Estructura con los datos del archivo CNF.

  ## Retorno
  - Lista de cadenas binarias que representan asignaciones válidas.
  """
  defp get_valid_values({:ok, cnf}) do
    max_value = trunc(:math.pow(2, cnf.variables)) - 1

    valid_assignments_tasks =
      for x <- 0..max_value do
        Task.async(fn ->
          assignment = integer_to_assignment(x, cnf.variables)
          if satisfies_all?(cnf.clauses, assignment) do
            assignment_to_binary(assignment, cnf.variables)
          else
            nil
          end
        end)
      end

    valid_assignments_tasks
    |> Enum.map(&Task.await/1)
    |> Enum.reject(&is_nil/1)
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
  Convierte un mapa de asignaciones a una cadena binaria.

  ## Parámetros
  - `assignment`: Mapa de asignaciones `{variable => valor}`.
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
  - `assignment`: Mapa de asignaciones `{variable => valor}`.

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
  - `list`: Lista de asignaciones válidas como cadenas binarias.

  ## Retorno
  - Cadena de texto formateada con las asignaciones separadas por espacios y líneas nuevas.
  """
  defp generate_message(list) do
    list
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.join("\n")
  end
end

CNFReaderV2.main()
