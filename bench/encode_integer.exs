Benchee.run(
  %{
    "ULID generate" => fn -> ULID.generate() end,
    "Ecto.ULID generate" => fn -> Ecto.ULID.generate() end
  }
)
