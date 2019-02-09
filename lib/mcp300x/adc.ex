defmodule MCP300X.ADC do
  @moduledoc false

  @spec to_volts(non_neg_integer()) :: float()
  def to_volts(n) do
    n * (3.3 / 1023)
  end

  @spec to_percent(non_neg_integer()) :: float()
  def to_percent(n) do
    n / 1023 * 100
  end

  @spec id(non_neg_integer()) :: non_neg_integer()
  def id(n), do: n
end
