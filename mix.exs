defmodule Notifiex.MixProject do
  use Mix.Project

  def project() do
    [
      app: :notifiex,
      version: "1.2.0",
      elixir: "~> 1.12",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs(),
      name: "Notifiex",
      source_url: "https://github.com/burntcarrot/notifiex"
    ]
  end

  def application do
    [
      mod: {Notifiex, []}
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 1.8"}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: "https://github.com/burntcarrot/notifiex",
      extras: ["README.md"]
    ]
  end

  defp description() do
    "A dead simple Elixir library for sending notifications to various messaging services."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "notifiex",
      # These are the default files included in the package
      files: ~w(lib static .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/burntcarrot/notifiex"}
    ]
  end
end
