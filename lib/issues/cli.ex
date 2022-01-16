defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to 
  the various functions that end up generating a
  table of the last _n_ issues in a GitHub repository.
  """

  def run(argv), do: parse_args(argv)

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a GH user name, repo name and (optionally)
  the number of issues to format.

  Return a tuple of `{user, repo, count}`, or :help if help
  was given.
  """
  def parse_args(argv) do
    parsed = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])

    case parsed do
      {[help: true], _, _} ->
        :help

      {_, [user, repo, count], _} ->
        {user, repo, String.to_integer(count)}

      {_, [user, repo], _} ->
        {user, repo, @default_count}

      _ ->
        :help
    end
  end
end
