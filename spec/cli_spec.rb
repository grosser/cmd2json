require "spec_helper"

describe "CLI" do
  def sh(command, fail: false)
    result = `#{command}`
    raise "FAIL:\n#{command}\n#{result}" if $?.success? == fail
    result.sub(/,"@timestamp":".+?"/, ',"@timestamp":"--TIME--"')
  end

  it "shows help" do
    expect(sh("cmd2json -h")).to include("Covert command output")
  end

  it "shows version" do
    expect(sh("cmd2json -v")).to match(/\A\d+\.\d+\.\d+\n\z/)
  end

  it "creates json" do
    expect(sh("cmd2json echo 1")).to eq(%{{"message":"1\\n","exit":0}\n})
  end

  it "can add info" do
    expect(sh("cmd2json -a foo=bar echo 1")).to eq(%{{"message":"1\\n","exit":0,"foo":"bar"}\n})
  end

  it "can add info multiple times" do
    expect(sh("cmd2json -a foo=bar -a bar=baz echo 1")).to eq(%{{"message":"1\\n","exit":0,"foo":"bar","bar":"baz"}\n})
  end

  it "can add host" do
    expect(sh("cmd2json --host echo 1")).to eq(%{{"message":"1\\n","exit":0,"host":"#{Socket.gethostname}"}\n})
  end

  it "can add timestamp" do
    expect(sh("cmd2json --timestamp echo 1")).to eq(%{{"message":"1\\n","exit":0,"@timestamp":"--TIME--"}\n})
  end

  it "can fail" do
    expect(sh("cmd2json false", fail: true)).to eq(%{{"message":"","exit":1}\n})
  end

  it "can fail" do
    expect(sh("cmd2json ls fail", fail: true)).to eq(%{{"message":"ls: fail: No such file or directory\\n","exit":1}\n})
  end

  it "captures stderr" do
    expect(sh("cmd2json sh -c 'echo foo 1>&2'")).to eq(%{{"message":"foo\\n","exit":0}\n})
  end

  it "reports when killed" do
    skip "cannot kill my own sub-process ... so run kill manually to test"
    [
      Thread.new { expect(sh("cmd2json sleep 100", fail: true)).to eq(%{{"message":"\nKilled SIGTERM","exit":1}}) },
      Thread.new do
        sleep 0.1 # wait for other thread to start
        processes = `ps -ef | grep '[c]md2json sleep'`
        pid = processes.split(/\s+/)[2] || raise("No pid")
        puts "kill #{pid}"
        # Process.kill(:TERM, pid.to_i)
      end
    ].map(&:join)
  end
end
