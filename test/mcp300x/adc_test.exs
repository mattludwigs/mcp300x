defmodule MCP300X.ADC.Test do
  use ExUnit.Case, async: true

  alias MCP300X.ADC

  test "does nothing to the value" do
    assert 100 == ADC.id(100)
  end

  test "converts to percent" do
    assert 50.0 == ADC.to_percent(511.5)
  end

  test "converts to volts" do
    assert 1.5 == ADC.to_volts(465)
  end
end
