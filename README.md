# MCP300X

[![CircleCI](https://circleci.com/gh/mattludwigs/mcp300x.svg?style=svg)](https://circleci.com/gh/mattludwigs/mcp300x)

Library for working the MCP300X Analog-to-Digitial Converters.

## Road map

This library is under active development and supports single channel
reads using the MCP3008 ADC. So, here is the goals of this library:

- [ ] Support MCP3002
- [ ] Support MCP3004
- [ ] Support Differential Reads
- [ ] Support MSBF


## Basic usage

Assuming that you have a potentiometer to the `0` channel on the MCP3008
you could call 

```elixir
MCP300X.read_channel("spidev0.0", MCP300X.MCP3008, 0)
```

This will proivde the raw reading from the ADC. To get volts you can pass in the `MCP300X.to_volts/1` function:

```elixir
MCP300X.read_channel("spidev0.0", MCP300X.MCP3008, 0, convert_func: &MCP300X.to_volts/1)`
```

The `convert_func` option is a function that will run on the output of the ADC. By
default this is the `MCP300X.id/1` function, which is just a pass through of the raw
value.

Also, there is `MCP300X.Server` that you can run in your superivsion tree that
will keep the SPI connection open for faster reads.


```elixir
children = [
{MCP300X.Server, ["spidev0.0", MCP300X.MCP3008, [name: MyApp.MCP3008]]}
]

opts = [strategy: :one_for_one, name: MyApp.Supervisor]

Supervisor.start_link(children, opts)


# Calling

MCP300X.Server.read_channel(MyApp.MCP3008, 0)
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mcp300x` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mcp300x, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/mcp300x](https://hexdocs.pm/mcp300x).


## Datasheets

- [MCP3008](https://www.microchip.com/wwwproducts/en/en010530)

