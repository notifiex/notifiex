defmodule Notifiex.MixProject do
  use Mix.Project

  def project do
    [
      app: :notifiex,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:httpoison, "~> 1.8"},
      {:poison, "~> 5.0"}
    ]
  end
end
