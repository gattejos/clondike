require 'socket'
require 'Util.rb'
require 'cli/SmartCommandLine.rb'

# Class that connects to CliServer and interacts with it via TCP
class CliClient
  def initialize(port)
    @port = port
  end

  def connect
    @sock = TCPSocket.open("localhost",@port)
    @lineInterpreter = LineInterpreter.new(@sock)
  end

  def run
    @commandLine = SmartCommandLine.new("Director> ", ".cmd.history", @lineInterpreter)
    begin
      @commandLine.run()
    ensure
      @sock.close
    end
  end

  def runSingleCommand(command)
    begin
      @lineInterpreter.interpret(command)
    ensure
      @sock.close
    end
  end

  class LineInterpreter
    def initialize(sock)
      @sock = sock
    end

    def interpret(line)
      @sock.puts(line)
      @sock.flush
      reply = ""

      begin
        while ( !reply.endsWith("\n") )  do
          reply = reply + @sock.readpartial(4096)
        end
      rescue EOFError
        # end of readpartial
      end
      reply = reply.chop!

      return reply
    end
  end
end

client = CliClient.new(4223)

begin
  client.connect
rescue => err
  puts "Failed to connect to the server:\n#{err.backtrace.join("\n")}"
  exit 1
end

begin
  if ( ARGV.length == 0 )
    client.run
  else
    client.runSingleCommand(ARGV[0])
  end
rescue => err
  puts "#{err}\n#{err.backtrace.join("\n")}"
end

