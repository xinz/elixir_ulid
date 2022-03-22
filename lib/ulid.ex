defmodule ULID do
  @moduledoc """
  Documentation for `ULID`.
  """

  defmodule Base32 do
    use CrockfordBase32,
      bits_size: 128
  end

  def generate(timestamp \\ System.system_time(:millisecond))
      when is_integer(timestamp) and timestamp >= 0 do
    Base32.encode(generate_binary(timestamp))
  end

  def generate_binary(timestamp \\ System.system_time(:millisecond))
      when is_integer(timestamp) and timestamp >= 0 do
    <<timestamp::unsigned-size(48), random_bytes()::binary>>
  end

  def decode(<<timestamp::unsigned-size(48), random::bytes-size(10)>>) do
    {:ok, timestamp, random}
  end

  def decode(<<_encoded_timestamp::bytes-size(10), _random::bytes-size(16)>> = input) do
    with {:ok, <<timestamp::unsigned-size(48), random::binary>>} <-
           Base32.decode(input) do
      {:ok, timestamp, random}
    else
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
