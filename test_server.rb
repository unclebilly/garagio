require './init'
class TestServer
  attr_accessor :state, :down

  def initialize
    @port = 2000
    @socket = TCPServer.new(@port)
    @down = false  # true == first pass of relay open (relay clicks on, off to simulate button press)
    @state = false # true == open
    accept
  end

  def accept
    @client = @socket.accept
    @client.read(Wifly::COMMAND_MODE.length)
    @client.write(Wifly::HELLO)
    detect_input
  end

  def detect_input
    loop do
      begin
        str = @client.read_nonblock(3000)
      rescue Errno::EAGAIN => e
        IO.select([@client])
        retry
      end
      dispatch(str)
    end
  end

  def dispatch(str)
    puts "handling #{str}"
    write = case str
    when /show io/
      str.strip + "\r\r\n#{self.io}\r\n<" + version + "> "
    when /set sys output/
      self.down = !self.down
      str.strip + "\r\r\nAOK\r\n<" + version + "> "
    else
      puts "no match for '#{str}'"
      exit
    end
    puts write
    @client.write(write)
    detect_input
  end

  def down=(new_state)
    self.state = !self.state if (new_state)
    @down = new_state
  end
  
  def io
    self.state ? "ad08" : "8d08"
  end

  def version
    CONFIG[:firmware_version]
  end

end
if $0 == __FILE__
  TestServer.new
end
