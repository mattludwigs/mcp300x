defmodule MCP300X.MCP3008.Test do
  use ExUnit.Case, async: true

  alias MCP300X.MCP3008

  describe "correctly enocdes the channel read byte" do
    test "read channel 0" do
      assert 0x80 == MCP3008.channel_read_byte(0)
    end

    test "read channel 1" do
      assert 0x90 == MCP3008.channel_read_byte(1)
    end

    test "read channel 2" do
      assert 0xA0 == MCP3008.channel_read_byte(2)
    end

    test "read channel 3" do
      assert 0xB0 == MCP3008.channel_read_byte(3)
    end

    test "read_channel 4" do
      assert 0xC0 == MCP3008.channel_read_byte(4)
    end

    test "read channel 5" do
      assert 0xD0 == MCP3008.channel_read_byte(5)
    end

    test "read channel 6" do
      assert 0xE0 == MCP3008.channel_read_byte(6)
    end

    test "read channel 7" do
      assert 0xF0 == MCP3008.channel_read_byte(7)
    end

    test "errors on invalid flags" do
      assert {:error, {:out_of_bounds_channel, 19}} == MCP3008.channel_read_byte(19)
    end
  end
end
