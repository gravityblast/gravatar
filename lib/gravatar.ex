defmodule Gravatar do
  defstruct [secure: false, email: "", opts: nil]

  @host      "www.gravatar.com"
  @base_path "/avatar"

  def new(email) when is_binary(email) do
    %Gravatar{} |> email(email)
  end

  def email %Gravatar{} = gravatar, email do
    %{gravatar | email: email}
  end

  def secure %Gravatar{} = gravatar do
    %{gravatar | secure: true}
  end

  def size(%Gravatar{opts: nil} = gravatar, s) when is_number(s) do
    %{gravatar | opts: %{}} |> size(s)
  end

  def size(%Gravatar{} = gravatar, size) when is_number(size) do
    opts = Map.put gravatar.opts, :s, size
    Map.put gravatar, :opts, opts
  end

  def to_uri %Gravatar{} = gravatar do
    %URI{
      scheme: scheme_for(gravatar),
      host: @host,
      path: path_for(gravatar.email),
      query: query_for(gravatar)
    }
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
