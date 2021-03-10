
defmodule ReportsGenerator do

  def build(filename) do
    "reports/#{filename}"
    |>File.stream!()
    |>Enum.reduce(report_acc(), fn line, report ->
       [id, _food_name, price] = parse_line(line)
       Map.put(report, id, report[id] + price)
      end)
  end

  defp parse_line(line) do
    line
    |>String.trim()
    |>String.split(",")
    |>List.update_at(2, &String.to_integer/1)
  end

  defp report_acc, do: Enum.into(1..30, %{}, fn(elem) -> {Integer.to_string(elem), 0} end)

  # def handle_file({:ok, file_content}), do: file_content

  # def handle_file({:error, _reason}), do: "There was an error opening the file!"
  # Enum.into(1..30, %{}, fn(elem) -> {elem, 0} end)


  # example below uses cases

  # def build(filename) do
  #  case  File.read("reports/#{filename}") do
  #    {:ok, file} -> file
  #    {:error, reason} -> reason
  #  end
  # end

  def hello do
    :world
  end
end
