defmodule ULID do
  @moduledoc """
  Documentation for `ULID`.
  """

  defmodule Base32.Bits128 do
    use CrockfordBase32,
      bits_size: 128,
      type: :integer
  end

  def generate(timestamp \\ System.system_time(:millisecond))
      when is_integer(timestamp) and timestamp >= 0 do
    Base32.Bits128.encode(generate_binary(timestamp))
  end

  def generate_binary(timestamp \\ System.system_time(:millisecond))
      when is_integer(timestamp) and timestamp >= 0 do
    <<timestamp::unsigned-size(48), random_bytes()::binary>>
  end

  def decode_binary(<<timestamp::unsigned-size(48), random::bytes-size(10)>>) do
    {:ok, timestamp, random}
  end

  def decode(<<_encoded_timestamp::bytes-size(10), _random::bytes-size(16)>> = input) do
    case Base32.Bits128.decode_to_bitstring(input) do
      {:ok, <<timestamp::unsigned-size(48), random::bitstring>>} ->
        {:ok, timestamp, random}
      _ ->
        error_invalid_decoding()
    end
  end
  def decode(_), do: error_invalid_decoding()

  defp random_bytes() do
    :crypto.strong_rand_bytes(10)
  end

  defp error_invalid_decoding(), do: {:error, "invalid"}
end
