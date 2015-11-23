defmodule Matrix.Fetcher do
  @moduledoc"""
  Module that does fetching of data.
  """
  use HTTPoison.Base
  alias Matrix.Atomifier

  def request(method, url, body, headers, []) do
    super(method, url, body, headers, [{:ssl, verify: :verify_none}])
  end

  def process_url(url) do
    Application.get_env(:matrix, :server) <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Atomifier.atomify 
  end

  def fetch(url) do
    get!(url).body
  end

  def send(url, data) do
    post!(url,
    Poison.encode!(data),
    [{"content-type", "x-www-form-urlencoded"}]).body
  end
end
