require 'socket'

class WiFly
  attr_accessor :address, :port

  def initialize(address, port)
    self.address = address
    self.port = port
    push("$$$")
  end

  def toggle
    push("lites")
    sleep 2
    push("lites")
  end

  def push(str)
    socket.write(str + "\r")
    begin
      socket.read_nonblock(10_000)
    rescue IO::WaitReadable
      
    end
  end

  def socket
    @socket ||= Socket.tcp(address, port)
  end
end