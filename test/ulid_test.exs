defmodule ULIDTest do
  use ExUnit.Case
  doctest ULID

  test "ULID.generate/0 string by default" do
    assert String.length(ULID.generate()) == 26
    assert String.length(ULID.generate()) == 26
    assert String.length(ULID.generate()) == 26
  end

  test "ULID.generate/1 string by input integer" do
    ulid = ULID.generate(1)
    assert String.length(ulid) == 26
    assert String.starts_with?(ulid, "0000000001") == true
    ulid = ULID.generate(1000)
    assert String.starts_with?(ulid, "00000000Z8") == true
    assert String.length(ulid) == 26
  end

  test "ULID.generate_binary/0 by default" do
    assert bit_size(ULID.generate_binary()) == 128
    assert bit_size(ULID.generate_binary()) == 128
    assert bit_size(ULID.generate_binary()) == 128
  end

  test "ULID.generate_binary/1 by input integer" do
    assert bit_size(ULID.generate_binary(0)) == 128
    assert bit_size(ULID.generate_binary(98765)) == 128
  end

  test "sort generated items" do
    data =
      Enum.map(1..10, fn _i ->
        Process.sleep(10)
        ULID.generate()
      end)

    # in ascending order
    assert Enum.sort(data) == data

    Enum.map(data, fn item ->
      assert String.length(item) == 26
    end)
  end

  test "unique generated" do
    cores = System.schedulers_online()

    data =
      1..cores
      |> Task.async_stream(
        fn _ ->
          ULID.generate()
        end,
        timeout: :infinity
      )
      |> Enum.map(fn {:ok, item} -> item end)

    assert MapSet.new(data) |> MapSet.size() == cores
  end

  test "ULID.decode_binary/1" do
    binary = ULID.generate_binary()
    {:ok, timestamp, random_bytes} = ULID.decode_binary(binary)
    assert byte_size(random_bytes) == 10
    assert is_integer(timestamp) == true

    value = 256
    binary = ULID.generate_binary(value)
    {:ok, timestamp, random_bytes} = ULID.decode_binary(binary)
    assert byte_size(random_bytes) == 10
    assert timestamp == value

    binary = ULID.generate()
    {:ok, timestamp, _random_bytes} = ULID.decode(binary)
    Process.sleep(10)
    assert timestamp < System.system_time(:millisecond)

    value = 1025
    binary = ULID.generate(value)
    {:ok, timestamp, random_bytes} = ULID.decode(binary)
    assert timestamp == value
    assert byte_size(random_bytes) == 10
  end

  test "use unix-time in ms by default" do
    start = System.system_time(:millisecond)
    id = ULID.generate()
    {:ok, timestamp, _} = ULID.decode(id)
    assert timestamp >= start
  end

  test "ensure decode properly" do
    ms = 1648112381919
    id = ULID.generate(ms)
    {:ok, timestamp, _} = ULID.decode(id)
    assert timestamp == ms
  end
end
