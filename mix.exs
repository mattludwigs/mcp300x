defmodule MCP300X.MixProject do
  use Mix.Project

  def project do
    [
      app: :mcp300x,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: [extras: ["README.md"], main: "readme"],
      dialyzer: dialyzer()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:circuits_spi, "~> 0.1.3"},
      {:ex_doc, "~> 0.19", only: [:test, :dev], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:test, :dev], runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Matt Ludwigs"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/mattludwigs/mcp300x"}
    ]
  end

  defp description() do
    "An Elixir library for working with MCP300X family of ADCs"
  end

  defp dialyzer() do
    [
      flags: [:unmatched_returns, :error_handling, :race_conditions, :underspecs]
    ]
  end
end
