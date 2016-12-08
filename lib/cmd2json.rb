require 'json'

module Cmd2Json
  def self.run(argv, options={})
    begin
      out = ""
      IO.popen(argv, err: [:child, :out]) { |io| out = io.read }
      status = $?.exitstatus
    rescue Errno::ENOENT
      out = $!.message
      status = 1
    end
    result = {message: out, exit: status, timestamp: Time.now.to_s}
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
