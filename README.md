<img src = "static/notifiex.png">

<h4>Table of Contents:</h4>

- [Installation](#installation)
- [Usage](#usage)
- [Providers](#providers)
- [License](#license)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `notifiex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:notifiex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/notifiex](https://hexdocs.pm/notifiex).

## Usage

Here is an example on how Notifiex sends a Slack message:

```elixir
> Notifiex.send(:slack, %{text: "Notifiex is cool! 🚀", channel: "general"},  %{token: "SECRET"})
```

## Providers

Notifiex currently supports these providers:

- [x] Slack
- [ ] Discord

## License

Notifiex is licensed under the MIT License.
