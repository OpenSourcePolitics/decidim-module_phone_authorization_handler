# frozen_string_literal: true

require "decidim/dev/common_rake"

def fix_babel_config(path)
  Dir.chdir(path) do
    babel_config = "#{Dir.pwd}/babel.config.json"
    File.delete(babel_config) if File.exist?(babel_config)
    FileUtils.cp("#{__dir__}/babel.config.json", Dir.pwd)
  end
end
def install_module(path)
  Dir.chdir(path) do
    system("npm i @babel/plugin-proposal-private-property-in-object")
  end
end

desc "Generates a dummy app for testing"
task test_app: "decidim:generate_external_test_app" do
  ENV["RAILS_ENV"] = "test"
  fix_babel_config("spec/decidim_dummy_app")
  install_module("spec/decidim_dummy_app")
end

desc "Generates a development app."
task development_app: "decidim:generate_external_development_app"
