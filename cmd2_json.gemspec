name = "cmd2_json"
require "./lib/#{name.gsub("-","/")}/version"

Gem::Specification.new name, Cmd2Json::VERSION do |s|
  s.summary = "Covert command output and exit status to json to pipe them atomically into logs"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib/ bin/ MIT-LICENSE`.split("\n")
  s.license = "MIT"
  s.required_ruby_version = '>= 2.0.0'
end
