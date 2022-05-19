<h1>Discord</h1>

- [Retrieving Webhook URI](#retrieving-webhook-uri)
- [Using Notifiex](#using-notifiex)
  - [Sending messages](#sending-messages)
  - [Uploading files](#uploading-files)

## Retrieving Webhook URI

Retrieve your Discord webhook. [Here](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks) is an extensive guide on creating webhooks.

Once retrieved, it should be in the form of:

```
https://discord.com/api/webhooks/webhookid/token
```

## Using Notifiex

Once retrieved, [add Notifiex to your project](https://github.com/burntcarrot/notifiex#installation).

### Sending messages

Send a message to Discord:

```elixir
> Notifiex.send(:discord, %{content: "Notifiex is cool! 🚀"},  %{webhook: "SECRET"})
```

![Discord preview](../static/discord-preview.png)

### Uploading files

🏗️ The Discord service currently doesn't support file uploads. (_Work in progress_)
