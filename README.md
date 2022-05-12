<img src = "static/notifiex.png">

[ci]: https://github.com/burntcarrot/notifiex/actions/workflows/elixir.yml
[ci-badge]: https://github.com/burntcarrot/notifiex/actions/workflows/elixir.yml/badge.svg

[![Hex](https://img.shields.io/hexpm/v/notifiex.svg)](https://hex.pm/packages/notifiex)
[![Actions status][ci-badge]][ci]

<h4>Table of Contents:</h4>

- [Installation](#installation)
- [Usage](#usage)
- [Services](#services)
- [License](#license)

## Installation

[Notifiex](https://hex.pm/packages/notifiex) can be installed
by adding `notifiex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:notifiex, "~> 1.1.0"}
  ]
end
```

## Usage

Here is an example on how Notifiex sends a Slack message:

```elixir
> Notifiex.send(:slack, %{text: "Notifiex is cool! 🚀", channel: "general"},  %{token: "SECRET"})
```

Sending a Discord message:

```elixir
> Notifiex.send(:discord, %{content: "Notifiex is cool! 🚀"},  %{webhook: "SECRET"})
```

## Services

Notifiex currently supports these services:

- [x] Slack
- [x] Discord

Planned services:
- [ ] Linear
- [ ] Mailgun
- [ ] Microsoft Teams
- [ ] SendGrid
- [ ] Plivo
- [ ] Telegram
- [ ] Twitter
- [ ] Zulip
- [ ] Rocket.Chat
- [ ] Google Chat
- [ ] Mattermost

## License

Notifiex is licensed under the MIT License.
