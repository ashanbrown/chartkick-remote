source 'https://rubygems.org'

# Specify your gem's dependencies in chartkick.gemspec
gemspec

eval File.read('Gemfile-custom') if File.exist?('Gemfile-custom')

rails_version = ENV["RAILS_VERSION"] || "default"

rails = case rails_version
        when "master"
          {github: "rails/rails"}
        when "default"
          ">= 3.1.0"
        else
          "~> #{rails_version}"
        end

gem "rails", rails
