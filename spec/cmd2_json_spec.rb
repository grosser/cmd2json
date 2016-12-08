require "spec_helper"

SingleCov.covered!

describe Cmd2Json do
  it "has a VERSION" do
    expect(Cmd2Json::VERSION).to match /^[\.\da-z]+$/
  end
end
