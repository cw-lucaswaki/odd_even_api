# File: lib/mix/tasks/lint.ex

defmodule Mix.Tasks.Lint do
  use Mix.Task

  @moduledoc """
  Runs the Elixir formatter and Credo for code quality checks.

  This task combines the built-in Elixir formatter check with Credo's static code analysis,
  providing a comprehensive code quality check similar to RuboCop in Ruby.

  ## Usage

      mix lint

  This will run the formatter check to ensure all files are properly formatted,
  followed by Credo in strict mode to catch potential issues and style violations.

  If either the formatter check or Credo finds issues, the task will exit with a non-zero status code.
  """

  @shortdoc "Runs the Elixir formatter and Credo"
  def run(_) do
    IO.puts("Running formatter...")
    {_, res} = System.cmd("mix", ["format", "--check-formatted"], into: IO.stream(:stdio, :line))

    IO.puts("\nRunning Credo...")
    {_, res2} = System.cmd("mix", ["credo", "--strict"], into: IO.stream(:stdio, :line))

    if res > 0 or res2 > 0 do
      System.halt(1)
    end
  end
end
