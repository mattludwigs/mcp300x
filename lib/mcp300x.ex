defmodule MCP300X do
  @moduledoc """
  Library for working with MCP300X Analog-to-Digitial Converters.
  """

  alias MCP300X.ADC
  alias MCP300X.ADC.Driver
  alias Circuits.SPI

  @type channel_number :: non_neg_integer()

  @type convert_func :: (non_neg_integer() -> non_neg_integer())

  @typedoc """
  Options to use when reading a value form the ADC

  - `:convert_func` - A conversion function for the raw output to be passed through (default `&MCP300X.id/1`)
  """
  @type read_opt :: {:convert_func, convert_func()}

  @doc """
  Quickly read the `channel_number` from the ADC.

  This is useful when checking the value does not take place vary often
  or in debugging situations.

  If you are doing any serious work reading the ADC value you should
  use `MCP300X.Server` instead, as this function will always open
  and close the SPI device.

  Options

  - `:convert_func` - default `MCP300X.id/1`
  """
  @spec read_channel(binary() | charlist(), Driver.t(), channel_number, [read_opt]) ::
          {:ok, non_neg_integer()}
  def read_channel(bus_name, driver, channel_number, opts \\ []) do
    opts = merge_read_opts(opts)
    convert_func = Keyword.get(opts, :convert_func)

    with {:ok, mcp} <- SPI.open(bus_name),
         {:ok, value} <- apply(driver, :read_channel, [mcp, channel_number, convert_func]),
         :ok <- SPI.close(mcp) do
      {:ok, value}
    end
  end

  @doc """
  Helper conversion function that will take the raw output and
  turn it into a voltage reading
  """
  @spec to_volts(non_neg_integer()) :: float()
  defdelegate to_volts(n), to: ADC

  @doc """
  Helper conversion function that will take the raw output and
  turn it into a percent
  """
  @spec to_percent(non_neg_integer()) :: float()
  defdelegate to_percent(n), to: ADC

  @doc """
  Helper conversion function that will take the raw output and
  pass it along. Useful for default `:convert_func` option.
  """
  @spec id(non_neg_integer()) :: non_neg_integer()
  defdelegate id(n), to: ADC

  defp merge_read_opts(opts) do
    [
      convert_func: &id/1
    ]
    |> Keyword.merge(opts)
  end
end
