defmodule ChargenServerTest do
  use ExUnit.Case

  setup do
    Application.stop(:chargen_server)
    :ok = Application.start(:chargen_server)
  end

  test "receiving data" do
    opts = [:binary, packet: 0, active: false]
    {:ok, socket} = :gen_tcp.connect('localhost', Application.get_env(:chargen_server, :port), opts)
    {:ok, socket: socket}
    {:ok, data} = :gen_tcp.recv(socket, 73)
    assert String.valid?(data)
    assert String.at(data, -1) == "\n"
    {:ok, data} = :gen_tcp.recv(socket, 73)
    assert String.valid?(data)
    assert String.at(data, -1) == "\n"
  end
end
