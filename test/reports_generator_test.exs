defmodule ReportsGeneratorTest do

  use ExUnit.Case
  describe "build/1" do
    test "builds the report" do
      response = "report_test.csv"
      |> ReportsGenerator.build()

      expected_response = %{"foods" =>
      %{"açaí" => 1, "churrasco" => 2, "esfirra"
      => 3, "hambúrguer" => 2, "pastel" => 0, "pizza" => 2, "prato_feito" => 0,
       "sushi" => 0},
       "users" => %{"1" => 48, "10" => 36, "11" => 0, "12" => 0, "13" => 0, "14" => 0,
        "15" => 0, "16" => 0, "17" => 0, "18" => 0, "19" => 0, "2" => 45, "20" => 0,
        "21" => 0, "22" => 0, "23" => 0, "24" => 0, "25" => 0, "26" => 0, "27" => 0,
        "28" => 0, "29" => 0, "3" => 31, "30" => 0, "4" => 42, "5" => 49, "6" => 18, "7" => 27, "8" => 25, "9" => 24}}

      assert response == expected_response
    end
  end

  describe "fetch_higher_cost/2" do
    test "when the option is 'users', it returns the user that spends the most" do
      expected_response = {:ok, {"5", 49}}
      response = "report_test.csv"
      |> ReportsGenerator.build()
      |> ReportsGenerator.fetch_higher_cost("users")
      assert response == expected_response
    end
    test "when the option is 'foods', it returns the user that spends the most" do
      expected_response = {:ok, {"esfirra", 3}}
      response = "report_test.csv"
      |> ReportsGenerator.build()
      |> ReportsGenerator.fetch_higher_cost("foods")
      assert response == expected_response
    end
  end
  describe "build_from_many/1" do
    test "builds the report from a list" do
      files = ["report_1.csv", "report_2.csv", "report_3.csv"]
      expected_result = %{"foods" => %{"açaí" => 37742, "churrasco" => 37650, "esfirra" => 37462, "hambúrguer" => 37577, "pastel" => 37392, "pizza" => 37365, "prato_feito" => 37519, "sushi" => 37293}, "users" => %{"1" => 278849, "10" => 268317, "11" => 268877, "12" => 276306, "13" => 282953, "14" => 277084, "15" => 280105, "16" => 271831, "17" => 272883, "18" => 271421, "19" => 277720, "2" => 271031, "20" => 273446, "21" => 275026, "22" => 278025, "23" => 276523, "24" => 274481, "25" => 274512, "26" => 274199, "27" => 278001, "28" => 274256, "29" => 273030, "3" => 272250, "30" => 275978, "4" => 277054, "5" => 270926, "6" => 272053, "7" => 273112, "8" => 275161, "9" => 274003}}
      result = files |> ReportsGenerator.build_from_many()
      assert result == expected_result
    end
  end

  test "greets the world" do
    assert ReportsGenerator.hello() == :world
  end
end
