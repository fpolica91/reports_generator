
defmodule ReportsGenerator do

  @available_foods  [
    "sushi",
    "açaí",
    "hambúrguer",
    "churrasco",
    "pizza",
    "prato_feito",
    "pastel",
    "esfirra"
  ]

  @options ["foods", "users"]

  alias ReportsGenerator.Parser
  def build(filename) do
    filename
    |>Parser.parse_file()
    |>Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  def build_from_many(filenames) when not is_list(filenames) do
    {:error, "Please provide a list"}
  end

  def build_from_many(filenames) do
    filenames
    |> Task.async_stream(fn filename -> build(filename) end)
    |> Enum.reduce(report_acc(), fn {:ok, result}, rept ->
       sum_reports(rept, result)
      end)

  end

  defp sum_reports(%{"foods" => foods1, "users" => users1}, %{"foods" => foods2, "users" => users2} ) do
   foods = merge_maps(foods1, foods2)
   users = merge_maps(users1, users2)
   build_report(foods, users)
  end

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> value1 + value2 end)
  end

  def fetch_higher_cost(report, option) when option in @options do
    {:ok, Enum.max_by(report[option], fn {_key, value} -> value end)}
  end
  def fetch_higher_cost(_, _), do: {:error, "Invalid Option"}

  defp sum_values([id, food_name, price], %{"users" => users, "foods" => foods}) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)
    build_report(foods, users)
  end

  defp report_acc do
    foods = Enum.into(@available_foods, %{}, &{&1, 0})
    users = Enum.into(1..30, %{}, fn(elem) -> {Integer.to_string(elem), 0} end)
    build_report(foods, users)
  end

  defp build_report(foods, users), do: %{"foods" => foods, "users" => users}

  def hello do
    :world
  end
end
