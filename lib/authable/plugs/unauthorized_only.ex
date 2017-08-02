defmodule Authable.Plug.UnauthorizedOnly do
  @moduledoc """
  Authable plug implementation to refute authencated users to access resources.
  """

  import Plug.Conn
  alias Authable.Helper

  def init([]), do: false

  @doc """
  Plug function to refute authencated users to access resources.

  ## Examples

      defmodule SomeModule.AppController do
        use SomeModule.Web, :controller
        plug Authable.Plug.UnauthorizedOnly when action in [:register]

        def register(conn, _params) do
          # only not logged in user can access this action
        end
      end
  """
  def call(conn, _opts) do
    response_conn_with(conn, Helper.authorize_for_resource(conn, []))
  end

  defp response_conn_with(conn, nil), do: conn
  defp response_conn_with(conn, {:error, _, _}), do: conn
  defp response_conn_with(conn, _) do
    renderer = renderer()
    conn
    |> renderer.render(:bad_request, %{errors: %{details: "Only unauhorized access allowed!"}})
    |> halt
  end

  defp renderer,
    do: Application.get_env(:authable, :renderer)
end
