defmodule Issues.CLI do
  import Issues.TableFormatter, only: [print_table_for_columns: 2]

  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last _n_ issues in a GitHub repository.
  """

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns   `:help`.

  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format

  Return a tuple of `{user, repo, count}`, or :help if help
  was given.
  """
  def parse_args(argv) do
    OptionParser.parse(argv,
      switches: [help: :boolean],
      aliases: [h: :help]
    )
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, repo, count]) do
    {user, repo, String.to_integer(count)}
  end

  def args_to_internal_representation([user, repo]) do
    {user, repo, @default_count}
  end

  # bad arg or --help
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

  def process({user, repo, count}) do
    Issues.GitHubIssues.fetch(user, repo)
    |> decode_response()
    |> sort_into_descending_order()
    |> last(count)
    |> print_table_for_columns(["number", "created_at", "title"])
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts("Error fetching from GitHub: #{error["message"]}")
    System.halt(2)
  end

  def last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse()
  end

  def sort_into_descending_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(fn i1, i2 ->
      i1["created_at"] >= i2["created_at"]
    end)
  end
end
