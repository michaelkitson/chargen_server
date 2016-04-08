defmodule ChargenServer do
  use Application
  require Logger

  @doc """
  Start supervisor.
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Task.Supervisor, [[name: ChargenServer.TaskSupervisor]]),
      worker(Task, [ChargenServer, :accept, [Application.get_env(:chargen_server, :port)]])
    ]

    opts = [strategy: :one_for_one, name: ChargenServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Start listening for new TCP connections on the given port.
  """
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: 0, active: false, reuseaddr: true])
    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  @doc """
  Accept TCP connections on the given port. Forks new connections off into new Tasks.
  """
  def loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Logger.info("New connection")
    {:ok, pid} = Task.Supervisor.start_child(ChargenServer.TaskSupervisor, fn -> send_loop(client, ChargenData.get_data(), 0) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  @doc """
  Sends the socket the given data in a loop until the client disconnects.
  """
  def send_loop(socket, data, bytes_sent) do
    result = :gen_tcp.send(socket, data)
    if result != :ok do
      Logger.info("Connection closed, sent #{bytes_sent} bytes")
    else
      send_loop(socket, data, bytes_sent + byte_size(data))
    end
  end
end
