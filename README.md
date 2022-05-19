<img src = "static/notifiex.png">

[ci]: https://github.com/burntcarrot/notifiex/actions/workflows/elixir.yml
[ci-badge]: https://github.com/burntcarrot/notifiex/actions/workflows/elixir.yml/badge.svg

[![Hex](https://img.shields.io/hexpm/v/notifiex.svg)](https://hex.pm/packages/notifiex)
[![Actions status][ci-badge]][ci]

> ❤️ If you're using Notifiex for your project, or in your company, please say a hi 👋 [here!](https://github.com/burntcarrot/notifiex/issues/1)

**Why Notifiex?**
- 📦 Easy-to-use, supports multiple [services](#services)!
- ⬆️ File upload support! (_to the notification services that will accept them_)
- ⚡ Incredibly lightweight (_minimal dependencies_)
- 🤹 Asynchronous notification dispatching (using Tasks and Supervisor)

<h4>Table of Contents:</h4>

- [Installation](#installation)
- [Usage](#usage)
- [Services](#services)
- [Plugins](#plugins)
- [File Uploads](#file-uploads)
- [License](#license)
- [Acknowledgements](#acknowledgements)

## Installation

[Notifiex](https://hex.pm/packages/notifiex) can be installed
by adding `notifiex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:notifiex, "~> 1.2.0"}
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

Sending in async mode (through Tasks and Supervisors):

```elixir
> Notifiex.send_async(:discord, %{content: "Notifiex is cool! 🚀"},  %{webhook: "SECRET"})
```

Sending multiple messages:

```elixir
notifs = [
  slack_test: {:slack, %{text: "Notifiex is cool! 🚀", channel: "general"},  %{token: "SECRET"}},
  discord_test: {:discord, %{content: "Notifiex is cool! 🚀"},  %{webhook: "SECRET"}}
]

# send synchronously
Notifiex.send_multiple(notifs)

# send in async mode
Notifiex.send_async_multiple(notifs)
```

## Services

Notifiex currently supports these services:

- [x] Slack (check [guide](https://github.com/burntcarrot/notifiex/blob/main/guides/slack.md) 📖)
- [x] Discord (check [guide](https://github.com/burntcarrot/notifiex/blob/main/guides/discord.md) 📖)

## Plugins

> 📢 Notifiex now supports custom plugins! [Here's a complete guide](https://github.com/burntcarrot/notifiex/blob/main/guides/plugins.md) on creating and using plugins!

As a starter, you can create a plugin for any of these services:

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

## File Uploads

Notifiex supports uploading files (text-based, binaries, etc.) to:
- [x] Slack
- [ ] Discord

## License

Notifiex is licensed under the MIT License.

## Acknowledgements

notifiex is inspired by [ravenx](https://github.com/acutario/ravenx). Please do check out their project!
