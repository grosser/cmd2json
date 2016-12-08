require 'json'
require 'socket'

module Cmd2Json
  def self.run(argv, options={})
    out = ""
    begin
      IO.popen(argv, err: [:child, :out]) { |io| out = io.read }

      # log when subprocess was killed, need manual testing as integration test
      unless status = $?.exitstatus
        out << "\nKilled"
        status = 1
      end
    rescue Errno::ENOENT # executable not found
      out = $!.message
      status = 1
    rescue SignalException # need manual testing as integration test
      out << "\nKilled #{$!}"
      status = 1
    end

    result = {message: out, exit: status}
    result['@timestamp'] = Time.now if options[:timestamp]
    result[:host] = Socket.gethostname if options[:host]
    [status, result.merge(options[:add] || {}).to_json]
  end

  # split options from argv so we can reuse the rest as command
  # -a 1 echo hello -> -a 1 + echo hello
  def self.extract_options!(argv, parser)
    list = parser.top.list
    options = []
    loop do
      arg = argv.first
      break unless option = list.detect { |o| o.short.include?(arg) || o.long.include?(arg) }

      options << argv.shift
      options << argv.shift if option.arg
    end
    options
  end
end
