defmodule CNFReaderV2 do
  defstruct variables: 0, clauses_count: 0, clauses: []

  def main do
    :observer.start()
    "uf20-01.cnf"
    |> read_cnf_file()
    |> measure_get_valid_values()
    |> generate_message()
    |> IO.puts()
  end

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


  defp measure_get_valid_values({:ok, cnf}) do
    {time, result} = :timer.tc(fn -> get_valid_values({:ok, cnf}) end)
    IO.puts("Tiempo de ejecución de get_valid_values: #{time / 1_000_000} segundos")
    result
  end

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

  defp parse_problem_line(line, acc) do
    case String.split(line) do
      ["p", "cnf", vars, clauses] ->
        %{acc | variables: String.to_integer(vars), clauses_count: String.to_integer(clauses)}
      _ ->
        IO.puts("Línea de problema malformada: #{line}")
        acc
    end
  end

  defp parse_clause(line, acc) do
    literals =
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> Enum.reject(&(&1 == 0))

    %{acc | clauses: acc.clauses ++ [literals]}
  end

  defp validate_cnf(cnf) do
    if cnf.clauses_count == length(cnf.clauses) do
      {:ok, cnf}
    else
      {:error, "El número de cláusulas no coincide con lo especificado en la línea de problema."}
    end
  end

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

  defp integer_to_assignment(integer, variables) do
    0..(variables - 1)
    |> Enum.map(fn i ->
      {i + 1, if(Bitwise.band(Bitwise.bsr(integer, i), 1) == 1, do: 1, else: 0)}
    end)
    |> Map.new()
  end

  defp assignment_to_binary(assignment, variables) do
    1..variables
    |> Enum.map(fn i -> Integer.to_string(Map.get(assignment, i, 0)) end)
    |> Enum.join()
  end

  defp satisfies_all?(clauses, assignment) do
    Enum.all?(clauses, fn clause ->
      Enum.any?(clause, fn literal ->
        (literal > 0 and Map.get(assignment, literal, 0) == 1) or
        (literal < 0 and Map.get(assignment, -literal, 0) == 0)
      end)
    end)
  end

  defp generate_message(list) do
    list
    |> Enum.map(&String.graphemes/1)  # Divide cada string en caracteres
    |> Enum.map(&Enum.join(&1, " "))  # Une los caracteres con un espacio
    |> Enum.join("\n")  # Une los mensajes con una nueva línea
  end
end

CNFReaderV2.main()