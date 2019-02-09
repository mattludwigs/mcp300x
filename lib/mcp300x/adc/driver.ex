defmodule MCP300X.ADC.Driver do
  alias Circuits.SPI

  @callback read_channel(SPI.spi_bus(), MCP300X.channel_number(), MCP300X.convert_func()) ::
              {:ok, 1..1023} | {:error, term()}
end
