Benchee.run(
  %{
    "generate/0 from ULID" => fn -> ULID.generate() end,
    "generate/0 Ecto.ULID" => fn -> Ecto.ULID.generate() end,
    "generate/0 ExULID" => fn -> ExULID.ULID.generate() end
  },
  print: [fast_warning: false]
)

Benchee.run(
  %{
    "generate/1 from ULID " => fn -> ULID.generate(1648112381919) end,
    "generate/1 Ecto.ULID" => fn -> Ecto.ULID.generate(1648112381919) end,
    "generate/1 ExULID" => fn -> ExULID.ULID.generate(1648112381919) end
  },
  print: [fast_warning: false]
)
defmodule Bench.Ecto.ULID do
  def decode(value) do
    {:ok, bytes} = Ecto.ULID.dump(value)
    <<timestamp::unsigned-size(48), random::binary>> = bytes
    {timestamp, random}
  end
end

defmodule Bench.ULID do
  def decode(value) do
    {:ok, timestamp, random} = ULID.decode(value)
    {timestamp, random}
  end
end

defmodule Bench.ExULID do
  def decode(value) do
    {timestamp, random} = ExULID.ULID.decode(value)
    {timestamp, random}
  end
end

Benchee.run(
  %{
    "decode from Ecto.ULID" => fn -> Bench.Ecto.ULID.decode("01FYXFBJ1HKBBM93F13ZGMQHN7") end,
    "decode from ULID" => fn -> Bench.ULID.decode("01FYXFBJ1HKBBM93F13ZGMQHN7") end,
    "decode from ExULID" => fn -> Bench.ExULID.decode("01FYXFBJ1HKBBM93F13ZGMQHN7") end
  },
  print: [fast_warning: false]
)
