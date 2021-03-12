
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



  def fetch_higher_cost(report, option) when option in @options do
    {:ok, Enum.max_by(report[option], fn {_key, value} -> value end)}
  end
  def fetch_higher_cost(_, _), do: {:error, "Invalid Option"}

  defp sum_values([id, food_name, price], %{"users" => users, "foods" => foods} =  rep) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)
    rep
    |>Map.put("users", users)
    |>Map.put("foods", foods)

  end

  defp report_acc do
    foods = Enum.into(@available_foods, %{}, &{&1, 0})
    users = Enum.into(1..30, %{}, fn(elem) -> {Integer.to_string(elem), 0} end)

    %{"users" => users, "foods" => foods}
  end

  def hello do
    :world
  end
end
