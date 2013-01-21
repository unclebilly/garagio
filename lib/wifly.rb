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
    send_command("lites")
  end

  # Human-readable status of the pin we have connected
  # the reed switch to
  def door_state
    raw_state = read_io 
    raw_state[-1] == "8" ? "open" : "closed"
  end

  # Get the status of all IO pins on wifly
  def read_io
    cmd = "show io\r"

    # wifly spits back something like 'show io\r\r\n8d08\r\n<2.32> '
    # crucially, the middle part "8d08\r\n" is always the same length
    str = send_command("show io", "8d08\r\n".length)

    # Return only the middle part, which is the io state
    str.gsub(cmd,'').gsub(PROMPT,'').strip
  end

  def socket
    @socket ||= Socket.tcp(address, port)
  end

  private
  
  # The wifly echoes back the command (with carriage return)
  # plus another CRLF and the command prompt string.
  # Something like "lites\r\r\n<2.32> "
  # Since the string is predictable, we can do a blocking read.
  def send_command(str, return_len=0)
    str += "\r"
    socket.write(str)
    socket.read(str.length + "\r\n#{PROMPT}".length + return_len)
  end

end