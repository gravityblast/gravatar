defmodule Gravatar do
  @moduledoc """
  Simple module to generate Gravatar URLs
  """

  defstruct [secure: false, email: "", opts: nil]

  @host      "www.gravatar.com"
  @base_path "/avatar"

  @doc """
  Generates a gravatar url for a given email.

  ## Example

      > Gravatar.new("test@example.com")
        |> to_string

      # "http://www.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0"
  """
  def new(email) when is_binary(email) do
    %Gravatar{} |> email(email)
  end

  @doc """
  Sets https to the generated URL.

  ## Example

      > Gravatar.new("test@example.com")
        |> Gravatar.secure
        |> to_string

      # "https://www.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0"
  """
  def secure %Gravatar{} = gravatar do
    %{gravatar | secure: true}
  end

  @doc """
  Sets the size parameter in the query string.

  ## Example

      > Gravatar.new("test@example.com")
        |> Gravatar.size(500)
        |> to_string

      # "http://www.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0?s=500"
  """
  def size(%Gravatar{opts: nil} = gravatar, s) when is_number(s) do
    %{gravatar | opts: %{}} |> size(s)
  end

  def size(%Gravatar{} = gravatar, size) when is_number(size) do
    opts = Map.put gravatar.opts, :s, size
    Map.put gravatar, :opts, opts
  end

  @doc """
  Returns a URI representation for the Gravatar struct.

  ## Example

      > Gravatar.new("test.example.com") |> Gravatar.to_uri

      # %URI{authority: nil, fragment: nil, host: "www.gravatar.com",
         path: "/avatar/e016d237b9139e919a77983b7ed1e17d", port: nil, query: nil,
         scheme: "http", userinfo: nil}
  """
  def to_uri %Gravatar{} = gravatar do
    %URI{
      scheme: scheme_for(gravatar),
      host: @host,
      path: path_for(gravatar.email),
      query: query_for(gravatar)
    }
  end

  defp email %Gravatar{} = gravatar, email do
    %{gravatar | email: email}
  end

  defp query_for %Gravatar{} = gravatar do
    case gravatar.opts do
      nil ->
        nil
      opts ->
        URI.encode_query opts
    end
  end

  defp scheme_for %Gravatar{secure: true} = gravatar do
    "https"
  end

  defp scheme_for %Gravatar{} do
    "http"
  end

  defp path_for email do
    "#{@base_path}/#{hash_for(email)}"
  end

  defp hash_for email do
    :crypto.hash(:md5, email) |> Base.encode16(case: :lower)
  end
end

defimpl String.Chars, for: Gravatar do
  def to_string gravatar do
    gravatar
    |> Gravatar.to_uri
    |> URI.to_string
  end
end
