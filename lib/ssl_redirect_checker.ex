defmodule OddEvenApiWeb.SSLRedirectChecker do
  def exclude_ssl_redirect? do
    Application.get_env(:odd_even_api, :ssl_redirect) == false
  end
end
