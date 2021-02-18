defmodule ExWordNet.MixProject do
  use Mix.Project

  def project do
    [
      app: :exwordnet,
      version: "0.2.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        dialyzer: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      source_url: "https://github.com/indocomsoft/exwordnet",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      package: package(),
      description: description()
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
      {:dialyxir, "~> 1.1.0", only: :test, runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:plug_cowboy, "~> 2.0", only: :test},
      {:credo, "~> 1.5.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    "A library to read WordNet dataset"
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/indocomsoft/exwordnet"}
    ]
  end
end
