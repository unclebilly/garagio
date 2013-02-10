require 'socket'

class WiFly
  PROMPT = "<#{CONFIG[:firmware_version]}> "
  attr_accessor :address, :port, :logger

  def initialize(opts={})
    self.address = opts[:address] || CONFIG[:address]
    self.port = opts[:port] || CONFIG[:port]
    self.logger = opts[:logger]
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

  def high_pins
    io=read_io
                    #"8d08"   36104   "1000110100001000"   make it 16 bits
    binary_string = io       .hex     .to_s(2)             .rjust(io.size*4, '0')
    binary_string.reverse.split("").each_with_index.map do |value, pin|
      pin if value == "1"
    end.compact
    
  end

  def set_high
    return_length = "\r\nAOK".length 
    send_command "set sys output 0x0010 0x0010", return_length

  end

  def set_low
    return_length = "\r\nAOK".length 
    send_command "set sys output 0x0000 0x0010", return_length

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
    logger.info("Writing '#{str}' to socket") if logger
    socket.write(str)
    socket.read(str.length + "\r\n#{PROMPT}".length + return_len).tap do |s|
      logger.info("Read '#{s}' from socket") if logger
    end
  end

end