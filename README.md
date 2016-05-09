# Gravatar

Gravatar URLs module for Elixir.

## Installation

```elixir
def deps do
  [{:gravatar, "~> 0.1.0"}]
end
```

## Usage

```elixir
Gravatar.new("test@example.com")
|> to_string

# "http://www.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0"

Gravatar.new("test@example.com")
|> Gravatar.size(500)
|> to_string

# "http://www.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0?s=500"

Gravatar.new("test@example.com")
|> Gravatar.size(500)
|> Gravatar.secure
|> to_string

# "https://www.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0?s=500"
```

Check the [online documentation](https://hexdocs.pm/gravatar/) for more information.

## Author

* [Andrea Franz](http://gravityblast.com)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
