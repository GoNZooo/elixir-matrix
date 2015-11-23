defmodule Matrix do
  alias Matrix.Fetcher

  def login(user, password) do
    login_info = Fetcher.send("/_matrix/client/api/v1/login",
    %{
      :type => "m.login.password",
      :user => user,
      :password => password
    })
    {:ok, pid} = Agent.start_link(fn -> login_info end, name: :login_info)
  end

  def token do
    Agent.get(:login_info, fn i -> i.access_token end)
  end

  def home_server do
    Agent.get(:login_info, fn i -> i.home_server end)
  end

  def user_id do
    Agent.get(:login_info, fn i -> i.user_id end)
  end

  def init_sync do
    Fetcher.fetch("/_matrix/client/api/v1/initialSync" <>
    "?access_token=#{token}&limit=1")
  end
end
