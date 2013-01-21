require 'socket'

class WiFly
  PROMPT = "<2.32> "
  attr_accessor :address, :port

  def initialize(address=CONFIG[:address], port=CONFIG[:port])
    self.address = address
    self.port = port
    socket.write('$$$\r')
    socket.read(12) # "*HELLO*CMD\r\n"
  end

  def lites
    write("lites")
  end

  def read_io
    socket.write("show io\r")
    begin
      socket.read_nonblock(400)
    rescue Exception => e
      puts e
    end
  end

  def socket
    @socket ||= Socket.tcp(address, port)
  end

  private
  def write(str)
    str += "\r"
    socket.write(str)
    # The wifly echoes back the command (with carriage return)
    # plus another CRLF and the command prompt string.
    # Something like "lites\r\r\n<2.32> "
    # Since the string is predictable, we can do a blocking read.
    socket.read(str.length + "\r\n#{PROMPT}".length)
  end

end