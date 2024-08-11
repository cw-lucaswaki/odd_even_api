# File: lib/mix/tasks/lint.ex

defmodule Mix.Tasks.Lint do
  use Mix.Task

  @moduledoc """
  Runs the Elixir formatter and Credo for code quality checks.

  ## Usage

      mix lint           # Check for issues
      mix lint --fix     # Attempt to fix formatting issues

  This will run the formatter check to ensure all files are properly formatted,
  followed by Credo in strict mode to catch potential issues and style violations.

  If the --fix option is provided, it will attempt to correct formatting issues.
  """

  @shortdoc "Runs the Elixir formatter and Credo"
  def run(args) do
    {opts, _, _} = OptionParser.parse(args, switches: [fix: :boolean])

    formatter_result =
      if opts[:fix] do
        IO.puts("Running formatter with auto-correct...")
        {_, _} = System.cmd("mix", ["format"], into: IO.stream(:stdio, :line))
        0
      else
        IO.puts("Running formatter...")

        {_, res} =
          System.cmd("mix", ["format", "--check-formatted"], into: IO.stream(:stdio, :line))

        res
      end

    IO.puts("\nRunning Credo...")
    {_, credo_result} = System.cmd("mix", ["credo", "--strict"], into: IO.stream(:stdio, :line))

    if (opts[:fix] && credo_result > 0) ||
         (!opts[:fix] && (formatter_result > 0 || credo_result > 0)) do
      System.halt(1)
    end
  end
end
