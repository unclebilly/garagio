require 'socket'

class WiFly
  PROMPT = "<#{CONFIG[:firmware_version]}> "
  attr_accessor :address, :port, :logger

  def initialize(opts={})
    self.address = opts[:address] || CONFIG[:address]
    self.port = opts[:port] || CONFIG[:port]
    self.logger = opts[:logger]
    
    # enter command mode
    socket.write('$$$\r')
    socket.read(12) # "*HELLO*CMD\r\n"
  end

  def door_state
    high_pins.include?(CONFIG[:door_state_pin]) ? :open : :closed
  end

  def toggle_door
    pin = CONFIG[:relay_pin]
    set_high(pin)
    sleep 1
    set_low(pin)
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

  # Get an array of the pin numbers that have high voltage.
  def high_pins
    io=read_io
                    #"0x8d08" 36104   "1000110100001000"   make it 16 bits
    binary_string = io       .hex     .to_s(2)             .rjust(io.size*4, '0')
    binary_string.reverse.split("").each_with_index.map do |value, pin|
      pin if value == "1"
    end.compact 
  end

  # Set a given pin to high. Pins are counted (0-start) on a binary 
  # number from right to left (100 is pin 2).
  def set_high(pin)
    hex = pin_to_hex(pin)
    return_length = "\r\nAOK".length 
    send_command "set sys output #{hex} #{hex}", return_length
  end

  # Set a given pin to low.  Pins are counted (0-start) on a binary 
  # number from right to left (100 is pin 2).
  def set_low(pin)
    hex = pin_to_hex(pin)
    return_length = "\r\nAOK".length 
    send_command "set sys output 0x0000 #{hex}", return_length
  end

  def socket
    @socket ||= Socket.tcp(address, port)
  end

  private

  # pin 7 => 0b10000000 => 0x80
  # pin 4 => 0b10000    => 0x10
  def pin_to_hex(num)
    "0x%02x" % "1".ljust(num+1, "0").to_i(2)
  end

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