defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to 
  the various functions that end up generating a
  table of the last _n_ issues in a GitHub repository.
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a GH user name, repo name and (optionally)
  the number of issues to format.

  Return a tuple of `{user, repo, count}`, or :help if help
  was given.
  """
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, repo, count]) do
    {user, repo, String.to_integer(count)}
  end

  def args_to_internal_representation([user, repo]) do
    {user, repo, @default_count}
  end

  def args_to_internal_representation(_) do
    # This function will catch any bad args, or --help (even though
    # we aren't checking the switches parsed above)
    :help
  end

  def process(:help) do
    IO.puts("""
    Usage: issues <user> <repo> [<count>]
    """)

    System.halt(0)
  end

  def process({user, repo, _count}) do
    Issues.GitHubIssues.fetch(user, repo)
    |> decode_response()
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts "Error fetching from GitHub: #{error["message"]}"
    System.halt(2)
  end
end
