defmodule OAuth2.Strategy.EveSso do
  @moduledoc false

  use OAuth2.Strategy

  @defaults [
    strategy: __MODULE__,
    site: "https://esi.evetech.net",
    authorize_url: "https://login.eveonline.com/v2/oauth/authorize",
    token_url: "https://login.eveonline.com/v2/oauth/token",
  ]

  @json_library Jason

  def client(opts \\ []) do
    opts =
      @defaults
      |> Keyword.merge(Application.get_env(:oauth2, :strategy)[:evesso] || [])
      |> Keyword.merge(opts)

    opts
    |> OAuth2.Client.new()
    |> OAuth2.Client.put_serializer("application/json", @json_library)
  end

  def authorize_url!(params \\ [], opts \\ []) do
    opts
    |> client()
    |> OAuth2.Client.authorize_url!(params)
  end

  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.get_token!(client(), params, headers, opts)
  end

  def verify(token) do
    with [_ | [body | _]] <- token.access_token |> String.split("."),
         {:ok, json_string} <- Base.decode64(body, padding: false),
         {:ok, decoded} <- @json_library.decode(json_string),
         [_, _, id] <- String.split(decoded["sub"], ":"),
         int_id <- String.to_integer(id) do
      {:ok, Map.put(decoded, "character_id", int_id)}
    else
      {:error, json_error} -> {:error, json_error}
      :error -> {:error, "failed to decode base64"}
      _ -> {:error, "unexpected token format"}
    end
  end

  def refresh(refresh_token, opts \\ []) do
    client = client(opts)
    OAuth2.Client.new([
      strategy: OAuth2.Strategy.Refresh,
      client_id: client.client_id,
      client_secret: client.client_secret,
      site: "https://login.eveonline.com/v2",
      params: %{"refresh_token" => refresh_token, "scope" => opts[:scope] || ""}
    ])
    |> OAuth2.Client.put_serializer("application/json", @json_library)
    |> OAuth2.Client.get_token!([], [{"accept", "application/json"}])
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    # EVE SSO does not like to receive duplicate credentials such as Basic auth header and client_id in the body
    # OAuth2 adds them to both, so we need to delete the client_id parameter manually
    client
    |> put_header("Accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
    |> delete_param(:client_id)
  end

  defp delete_param(%{params: params} = client, key) do
    %{client | params: Map.delete(params, "#{key}")}
  end
end
