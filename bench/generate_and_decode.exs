Benchee.run(
  %{
    "ULID.generate/0" => fn -> ULID.generate() end,
    "Ecto.ULID.generate/0" => fn -> Ecto.ULID.generate() end,
    "ExULID.generate/0" => fn -> ExULID.ULID.generate() end
  },
  print: [fast_warning: false]
)

Benchee.run(
  %{
    "ULID.generate/1" => fn -> ULID.generate(1648112381919) end,
    "Ecto.ULID.generate/1" => fn -> Ecto.ULID.generate(1648112381919) end,
    "ExULID.generate/1" => fn -> ExULID.ULID.generate(1648112381919) end
  },
  print: [fast_warning: false]
)

defmodule Bench.Ecto.ULID do
  def decode(value) do
    #{:ok, bytes} = Ecto.ULID.dump(value)
    #<<timestamp::unsigned-size(48), random::binary>> = bytes
    #{timestamp, random}
    Ecto.ULID.dump(value)
  end
end

defmodule Bench.ULID do
  def decode(value) do
    #{:ok, timestamp, random} = ULID.decode(value)
    #{timestamp, random}
    ULID.Base32.Bits128.decode_to_bitstring(value)
  end
end

Benchee.run(
  %{
    "Ecto.ULID.decode/1" => fn -> Bench.Ecto.ULID.decode("01FYXFBJ1HKBBM93F13ZGMQHN7") end,
    "ULID.decode/1" => fn -> Bench.ULID.decode("01FYXFBJ1HKBBM93F13ZGMQHN7") end,
  },
  print: [fast_warning: false]
)
