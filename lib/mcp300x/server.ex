defmodule MCP300X.Server do
  @moduledoc """
  Use a MCP300X family ADC in a GenServer so it can be supervised.

  This is useful for long running applications that will need to
  read from the ADC.

  ```elixir
  children = [
    {MCP300X.Server, ["spidev0.0", MCP300X.MCP3008, [name: MyApp.MCP3008]]}
  ]

  opts = [strategy: :one_for_one, name: MyApp.Supervisor]
  Supervisor.start_link(children, opts)
  ```

  This you can use it so:

  ```elixir
  MCP300X.Server.read_channel(MyApp.MCP3008, 0)
  ```
  """

  use GenServer

  alias Circuits.SPI
  alias MCP300X.ADC.Driver

  @type t :: pid()

  @typedoc """
  Options for the MCP300X server.

  - `:convert_func` - a conversion function to be used when readin the ADC value (default `MCP300X.id/1`)
  - `:name` - a name for the server to globally register it (defaults to no name)
  """
  @type opt :: MCP300X.read_opt() | {:name, module | atom}

  defmodule State do
    @moduledoc false
    defstruct spi_bus: nil, driver: nil, opts: []
  end

  @doc """
  Start the server.

  Takes a SPI bus name, a `Driver.t()`, and `opt`.

  If the SPI bus is invalid you will get `{:error, :access_denied}` when
  trying to start this process.
  """
  @spec start_link(binary() | charlist(), Driver.t(), [opt]) ::
          {:ok, t()} | GenServer.on_start()
  def start_link(bus_name, driver, opts \\ []) do
    gen_server_opts = get_gen_server_opts(opts)
    GenServer.start_link(__MODULE__, [bus_name, driver, opts], gen_server_opts)
  end

  @spec read_channel(t(), MCP300X.channel_number()) :: {:ok, non_neg_integer()} | {:error, term()}
  def read_channel(server, channel_number) do
    GenServer.call(server, {:read_channel, channel_number})
  end

  @spec stop(t()) :: :ok
  def stop(server) do
    GenServer.stop(server)
  end

  def init([bus_name, driver, server_opts]) do
    opts = merge_opts(server_opts)

    case SPI.open(bus_name) do
      {:ok, spi_bus} ->
        {:ok, %State{driver: driver, spi_bus: spi_bus, opts: opts}}
    end
  end

  def handle_call(
        {:read_channel, channel_number},
        _from,
        %State{spi_bus: spi_bus, driver: driver, opts: opts} = state
      ) do
    convert_func = Keyword.get(opts, :convert_func)
    result = apply(driver, :read_channel, [spi_bus, channel_number, convert_func])
    {:reply, result, state}
  end

  def terminate(_, %State{spi_bus: spi_bus}) do
    SPI.close(spi_bus)
  end

  defp merge_opts(opts) do
    [
      convert_func: &MCP300X.id/1
    ]
    |> Keyword.merge(opts)
  end

  defp get_gen_server_opts(opts) do
    case Keyword.get(opts, :name) do
      nil -> []
      name -> [name: name]
    end
  end
end
