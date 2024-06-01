defmodule ExSeedifyWeb.UserController do
  use ExSeedifyWeb, :controller

  action_fallback ExSeedifyWeb.FallbackController

  @doc """
  Renders paginated list of users with active / recent active salary.
  """
  @spec list_users(conn :: Plug.Conn.t(), params :: map()) :: Plug.Conn.t()
  def list_users(conn, params) do
    params = atomize_keys(params)
    {pagination_params, filter_params} = Map.split(params, [:page, :page_size])

    data = ExSeedify.list_users_with_salaries(filter_params, pagination_params)
    render(conn, :list_users, data: data)
  end

  @doc """
  Send email invitation to users with active salary.
  """
  @spec invite_users(conn :: Plug.Conn.t(), params :: map()) :: Plug.Conn.t()
  def invite_users(conn, _params) do
    with :ok <- ExSeedify.invite_users() do
      conn
      |> put_status(:ok)
      |> json(%{message: "Invitation emails sent successfully."})
    end
  end

  # =======================================================================
  # Private Functions
  # =======================================================================
  defp atomize_keys(map = %{}) do
    Enum.into(map, %{}, fn {k, v} -> {atomize_key(k), atomize_keys(v)} end)
  end

  defp atomize_keys(not_a_map) do
    try do
      String.to_integer(not_a_map)
    rescue
      _error -> not_a_map
    end
  end

  defp atomize_key(key) when is_binary(key), do: String.to_existing_atom(key)
  defp atomize_key(key), do: key
end
