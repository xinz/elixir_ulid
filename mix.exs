defmodule ULID.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_ulid,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:crockford_base32, "~> 0.3"}
    ]
  end
end
