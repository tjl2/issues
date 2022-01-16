defmodule Issues.GitHubIssues do
  @user_agent [{"User-agent", "Elixir tim@tjl2.com"}]

  def fetch(user, repo) do
    issues_url(user, repo)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, repo) do
    "https://api.github.com/repos/#{user}/#{repo}/issues"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, body}
  end

  def handle_response({_, %{status_code: _, body: body}}) do
    {:error, body}
  end
end