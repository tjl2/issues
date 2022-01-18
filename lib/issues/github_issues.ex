defmodule Issues.GitHubIssues do
  require Logger
  @user_agent [{"User-agent", "Elixir tim@tjl2.com"}]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, repo) do
    Logger.info("Fetching #{user}'s repo #{repo}")

    issues_url(user, repo)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, repo) do
    "#{@github_url}/repos/#{user}/#{repo}/issues"
  end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    Logger.info("Got response: status code = #{status_code}")
    Logger.debug(fn -> inspect(body) end)

    {
      status_code |> check_for_error(),
      # A list of maps, each map is a GH issue
      body |> Poison.Parser.parse!()
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error
end
