defmodule MCP300X.MCP3008 do
  @moduledoc """
  A `MCP300X.ADC.Driver` for working with the MCP3008 ADC
  """
  @behaviour MCP300X.ADC.Driver

  alias Circuits.SPI

  @impl MCP300X.ADC.Driver
  def read_channel(spi_bus, channel_number, convert_func) do
    case SPI.transfer(spi_bus, <<0x01, channel_read_byte(channel_number), 0x00>>) do
      {:ok, <<_, value::size(16)>>} ->
        {:ok, convert_func.(value)}

      {:error, _reason} = error ->
        error
    end
  end

  @doc """
  Get the correct byte for reading the channel
  """
  @spec channel_read_byte(non_neg_integer()) :: byte
  def channel_read_byte(0), do: 0x80
  def channel_read_byte(n) when n < 8, do: channel_read_byte(0) + 16 * n

  def channel_read_byte(n) do
    {:error, {:out_of_bounds_channel, n}}
  end
end
