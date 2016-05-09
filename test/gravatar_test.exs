defmodule GravatarTest do
  use ExUnit.Case
  doctest Gravatar

  def hash email do
    :crypto.hash(:md5, email) |> Base.encode16(case: :lower)
  end

  test "new" do
    email = "foo@example.com"
    uri = Gravatar.new email

    assert to_string(uri) == "http://www.gravatar.com/avatar/#{hash(email)}"
  end

  test "secure" do
    email = "foo@example.com"
    uri = Gravatar.new(email)
          |> Gravatar.secure

    assert to_string(uri) == "https://www.gravatar.com/avatar/#{hash(email)}"
  end

  test "size" do
    email = "foo@example.com"
    uri = Gravatar.new(email)
          |> Gravatar.size(555)

    assert to_string(uri) == "http://www.gravatar.com/avatar/#{hash(email)}?s=555"
  end
end
