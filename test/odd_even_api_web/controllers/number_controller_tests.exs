defmodule OddEvenApiWeb.NumberControllerTest do
  use OddEvenApiWeb.ConnCase

  describe "check/2" do
    test "returns 'even' for even numbers", %{conn: conn} do
      conn = get(conn, Routes.number_path(conn, :check, 42))
      assert json_response(conn, 200) == %{"number" => 42, "result" => "even"}
    end

    test "returns 'odd' for odd numbers", %{conn: conn} do
      conn = get(conn, Routes.number_path(conn, :check, 43))
      assert json_response(conn, 200) == %{"number" => 43, "result" => "odd"}
    end

    test "returns error for non-integer input", %{conn: conn} do
      conn = get(conn, Routes.number_path(conn, :check, "not_a_number"))
      assert json_response(conn, 400) == %{"error" => "Invalid number provided"}
    end
  end
end
