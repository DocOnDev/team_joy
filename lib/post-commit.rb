#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'
require 'yaml'
require_relative 'git_commit'
require_relative 'graph_cms'

dirname = File.expand_path(File.dirname(__FILE__))

gitCommit = GitCommit.new
gitCommit.score_file = "#{dirname}/TJ_SCORES"
graph_cms = GraphCMS.new(gitCommit)

@config = YAML.load_file("#{dirname}/joy_config.yml")

uri = URI.parse(@config['cms']['uri'])

@request = Net::HTTP::Post.new(uri)
@request["Accept"] = "application/json"
@request["Authorization"] = "Bearer " + @config['cms']['token'] unless @config['cms']['public']
req_options = { use_ssl: uri.scheme == "https", }

@request.body = JSON.dump({"query" => graph_cms.query})

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(@request)
end

puts response.code
puts response.body
