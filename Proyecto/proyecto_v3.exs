defmodule CNFReaderV3 do
  @moduledoc """
  Módulo para procesar archivos CNF, encontrar asignaciones de variables que satisfacen las cláusulas
  y optimizar el cálculo mediante paralelismo.
  """

  defstruct variables: 0, clauses_count: 0, clauses: []
  @cant_hilos 8

  @doc """
  Punto de entrada principal del programa. Lee el archivo CNF, busca asignaciones válidas
  y genera un mensaje con los resultados.
  """
  def main do
    "uf20-01000.cnf"
    |> read_cnf_file()
    |> measure_get_valid_values()
    |> generate_message()
    |> IO.puts()
  end

  @doc """
  Lee un archivo CNF y lo convierte en una estructura CNFReaderV3.

  ## Parámetros
  - `file_path`: Ruta al archivo CNF.

  ## Retorno
  - `{:ok, %CNFReaderV3{}}` si el archivo fue leído y procesado correctamente.
  - `{:error, reason}` si ocurrió un error al leer el archivo.
  """
  def read_cnf_file(file_path) do
    case File.read(file_path) do
      {:ok, content} ->
        content
        |> String.split("\n")
        |> Enum.reduce(%CNFReaderV3{}, &process_line/2)
        |> validate_cnf()

      {:error, reason} ->
        {:error, "Error al leer el archivo: #{reason}"}
    end
  end

  @doc """
  Mide el tiempo de ejecución de `get_valid_values/1` y devuelve los resultados.

  ## Parámetros
  - `cnf`: Una estructura `{:ok, %CNFReaderV3{}}`.

  ## Retorno
  - Lista de asignaciones válidas.
  """
  defp measure_get_valid_values({:ok, cnf}) do
    {time, result} = :timer.tc(fn -> get_valid_values({:ok, cnf}) end)
    IO.puts("Tiempo de ejecución de get_valid_values: #{time / 1_000_000} segundos")
    result
  end

  @doc """
  Procesa una línea del archivo CNF y actualiza la estructura CNFReaderV3.

  ## Parámetros
  - `line`: Línea del archivo CNF.
  - `acc`: Acumulador de tipo `%CNFReaderV3{}`.

  ## Retorno
  - Estructura CNFReaderV3 actualizada.
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
  Parsea la línea de problema del archivo CNF, que contiene el número de variables y cláusulas.

  ## Parámetros
  - `line`: Línea de problema.
  - `acc`: Acumulador de tipo `%CNFReaderV3{}`.

  ## Retorno
  - Estructura CNFReaderV3 actualizada.
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
  Parsea una línea que representa una cláusula lógica y la agrega a la estructura CNFReaderV3.

  ## Parámetros
  - `line`: Línea de cláusula.
  - `acc`: Acumulador de tipo `%CNFReaderV3{}`.

  ## Retorno
  - Estructura CNFReaderV3 actualizada.
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
  Valida que el número de cláusulas coincida con el especificado en la línea de problema.

  ## Parámetros
  - `cnf`: Estructura `%CNFReaderV3{}`.

  ## Retorno
  - `{:ok, %CNFReaderV3{}}` si es válido.
  - `{:error, reason}` en caso contrario.
  """
  defp validate_cnf(cnf) do
    if cnf.clauses_count == length(cnf.clauses) do
      {:ok, cnf}
    else
      {:error, "El número de cláusulas no coincide con lo especificado en la línea de problema."}
    end
  end

  @doc """
  Encuentra todas las asignaciones de variables que satisfacen las cláusulas del archivo CNF
  utilizando paralelismo.

  ## Parámetros
  - `cnf`: Estructura `{:ok, %CNFReaderV3{}}`.

  ## Retorno
  - Lista de asignaciones válidas en formato binario.
  """
  defp get_valid_values({:ok, cnf}) do
    max_value = trunc(:math.pow(2, cnf.variables)) - 1
    range = div(max_value, @cant_hilos)

    tasks =
      for i <- 0..(@cant_hilos - 1) do
        init_value = i * range
        end_value = if i == @cant_hilos - 1, do: max_value, else: init_value + range - 1

        Task.async(fn ->
          Enum.reduce(init_value..end_value, [], fn x, acc ->
            assignment = integer_to_assignment(x, cnf.variables)
            if satisfies_all?(cnf.clauses, assignment) do
              [assignment_to_binary(assignment, cnf.variables) | acc]
            else
              acc
            end
          end)
        end)
      end

    tasks
    |> Enum.map(&Task.await(&1, 6_000_000))
    |> List.flatten()
  end

  @doc """
  Convierte un entero a un mapa de asignaciones de variables.

  ## Parámetros
  - `integer`: Número entero que representa la asignación.
  - `variables`: Cantidad de variables.

  ## Retorno
  - Mapa con las asignaciones.
  """
  defp integer_to_assignment(integer, variables) do
    0..(variables - 1)
    |> Enum.map(fn i ->
      {i + 1, if(Bitwise.band(Bitwise.bsr(integer, i), 1) == 1, do: 1, else: 0)}
    end)
    |> Map.new()
  end

  @doc """
  Convierte un mapa de asignaciones a un binario (cadena de ceros y unos).

  ## Parámetros
  - `assignment`: Mapa de asignaciones.
  - `variables`: Cantidad de variables.

  ## Retorno
  - Cadena binaria que representa la asignación.
  """
  defp assignment_to_binary(assignment, variables) do
    1..variables
    |> Enum.map(fn i -> Integer.to_string(Map.get(assignment, i, 0)) end)
    |> Enum.join()
  end

  @doc """
  Verifica si una asignación satisface todas las cláusulas del CNF.

  ## Parámetros
  - `clauses`: Lista de cláusulas.
  - `assignment`: Mapa de asignaciones.

  ## Retorno
  - `true` si satisface todas las cláusulas, `false` en caso contrario.
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
  Genera un mensaje de texto a partir de una lista de cadenas binarias.

  ## Parámetros
  - `list`: Lista de cadenas binarias.

  ## Retorno
  - Cadena formateada con cada binario en una línea.
  """
  defp generate_message(list) do
    list
    |> Enum.map(&String.graphemes/1)  # Divide cada string en caracteres
    |> Enum.map(&Enum.join(&1, " "))  # Une los caracteres con un espacio
    |> Enum.join("\n")  # Une los mensajes con una nueva línea
  end
end

CNFReaderV3.main()
