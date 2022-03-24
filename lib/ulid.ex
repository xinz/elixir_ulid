defmodule ULID do
  @moduledoc """
  Documentation for `ULID`.
  """

  defmodule TimestampBits do
    use CrockfordBase32,
      bits_size: 48,
      type: :integer
  end

  defmodule RandomBits do
    use CrockfordBase32,
      bits_size: 80
  end

  def generate(timestamp \\ System.system_time(:millisecond))
      when is_integer(timestamp) and timestamp >= 0 do
    TimestampBits.encode(timestamp) <> RandomBits.encode(random_bytes())
  end

  def generate_binary(timestamp \\ System.system_time(:millisecond))
      when is_integer(timestamp) and timestamp >= 0 do
    <<timestamp::unsigned-size(48), random_bytes()::binary>>
  end

  def decode_binary(<<timestamp::unsigned-size(48), random::bytes-size(10)>>) do
    {:ok, timestamp, random}
  end

  def decode(<<encoded_timestamp::bytes-size(10), random::bytes-size(16)>>) do
    with {:ok, timestamp} <- TimestampBits.decode(encoded_timestamp),
         {:ok, random_bytes} <- RandomBits.decode(random) do
      {:ok, timestamp, random_bytes}
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
