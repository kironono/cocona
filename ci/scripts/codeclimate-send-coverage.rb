#!/usr/bin/env ruby

require "codeclimate-test-reporter"

COVERAGE_FILE = File.join(ENV['CIRCLE_ARTIFACTS'], "coverage", ".resultset.json")

if (repo_token = ENV["CODECLIMATE_REPO_TOKEN"]) && !repo_token.empty?
  if File.exist?(COVERAGE_FILE)
    begin
      results = JSON.parse(File.read(COVERAGE_FILE))
    rescue JSON::ParserError => e
      $stderr.puts "Error encountered while parsing #{COVERAGE_FILE}: #{e}"
      exit(1)
    end

    CodeClimate::TestReporter.run(results)
  else
    $stderr.puts "Coverage results not found"
    exit(1)
  end
else
  $stderr.puts "Cannot post results: environment variable CODECLIMATE_REPO_TOKEN must be set."
  exit(0)
end
