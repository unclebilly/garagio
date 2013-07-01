require './init'
class TestServer
  attr_accessor :state

  def initialize
    @port = 2000
    @socket = TCPServer.new(@port)
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
      str.strip + "\r\r\n8d08\r\n<" + version + "> "
    when /set sys output/
      self.state = !self.state
      str.strip + "\r\r\nAOK\r\n<" + version + "> "
    else
      puts "no match for '#{str}'"
      exit
    end
    puts write
    @client.write(write)
    detect_input
  end

  def version
    CONFIG[:firmware_version]
  end

  def state 
    @state ||= true
  end
end
if $0 == __FILE__
  TestServer.new
end
