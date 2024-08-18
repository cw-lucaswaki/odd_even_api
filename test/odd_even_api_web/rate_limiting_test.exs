defmodule OddEvenApiWeb.RateLimitingTest do
  use OddEvenApiWeb.ConnCase, async: false

  @endpoint OddEvenApiWeb.Endpoint

  Application.put_env(:odd_even_api, :ssl_redirect, false)

  setup do
    :ets.delete_all_objects(OddEvenApi.PlugAttack.Storage)
    :ok
  end

  describe "Rate limiting behavior" do
    test "allows configured number of requests", %{conn: conn} do
      for _ <- 1..180 do
        conn = get(conn, ~p"/api/check/42")
        assert json_response(conn, 200)
      end

      conn = get(conn, ~p"/api/check/42")
      assert json_response(conn, 429)
      assert conn.resp_body =~ "Rate limit exceeded"
    end

    test "resets after the configured period", %{conn: conn} do
      for _ <- 1..180 do
        conn = get(conn, ~p"/api/check/42")
        assert json_response(conn, 200)
      end

      :timer.sleep(60_100)  # Added a slight buffer for safety

      conn = get(conn, ~p"/api/check/42")
      assert json_response(conn, 200)
    end

    test "limits requests per IP separately", %{conn: conn} do
      for _ <- 1..180 do
        conn = get(conn, ~p"/api/check/42")
        assert json_response(conn, 200)
      end

      conn = get(conn, ~p"/api/check/42")
      assert json_response(conn, 429)

      conn = %{conn | remote_ip: {192, 168, 1, 2}}
      conn = get(conn, ~p"/api/check/42")
      assert json_response(conn, 200)
    end

    test "handles under limit requests correctly", %{conn: conn} do
      for _ <- 1..100 do  # Below the limit
        conn = get(conn, ~p"/api/check/42")
        assert json_response(conn, 200)
      end

      conn = get(conn, ~p"/api/check/42")
      assert json_response(conn, 200)  # Should still succeed
    end

    test "handles burst requests", %{conn: conn} do
      # Simulate rapid requests
      for _ <- 1..180 do
        conn = get(conn, ~p"/api/check/42")
        assert json_response(conn, 200)
      end

      conn = get(conn, ~p"/api/check/42")
      assert json_response(conn, 429)
    end
  end
end
