require "spec_helper"

SingleCov.covered!

describe Cmd2Json do
  it "has a VERSION" do
    expect(Cmd2Json::VERSION).to match /^[\.\da-z]+$/
  end

  describe ".run" do
    def call(*args)
      result = Cmd2Json.run(*args)
      result.last.sub!(/,"timestamp":".+?"/, '')
      result
    end

    it "returns status and output" do
      expect(call(['echo', 'foo'])).to eq([0, "{\"message\":\"foo\\n\",\"exit\":0}"])
    end

    it "catches bad failures" do
      expect(call(['echofoo'])).to eq([1, "{\"message\":\"No such file or directory - echofoo\",\"exit\":1}"])
    end
  end

  describe ".extract_options!" do
    let(:parser) do
      OptionParser.new do |opts|
        opts.on("-a", "--add KEY=VALUE", "add a key value pair") { |v| raise }
        opts.on("-h", "--help", "Show this.") { raise }
        opts.on('-v', '--version', 'Show Version'){ raise }
      end
    end

    def call(argv)
      [argv, Cmd2Json.extract_options!(argv, parser)]
    end

    it "does nothing when there are no options" do
      expect(call(['a'])).to eq([['a'], []])
    end

    it "extracts switches" do
      expect(call(['-v', 'a'])).to eq([['a'], ['-v']])
    end

    it "extracts arguments" do
      expect(call(['-a', 'a', 'b'])).to eq([['b'], ['-a', 'a']])
    end

    it "ignores empty" do
      expect(call([])).to eq([[], []])
    end
  end
end
