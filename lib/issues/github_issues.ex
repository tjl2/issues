defmodule Issues.GitHubIssues do
  @user_agent [{"User-agent", "Elixir tim@tjl2.com"}]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, repo) do
    issues_url(user, repo)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, repo) do
    "#{@github_url}/repos/#{user}/#{repo}/issues"
  end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    {
      status_code |> check_for_error(),
      body |> Poison.Parser.parse!() # A list of maps, each map is a GH issue
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error
end
