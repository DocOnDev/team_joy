#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'
require 'yaml'
require_relative 'joy_config'
require_relative 'git_commit'
require_relative 'graph_cms_query'

class GraphCmsRequestor

  def execute(query)
  end

end

def formulate_query()
  git_commit = GitCommit.new
  graph_query = GraphCmsQuery.new(git_commit)
  query = graph_query.query
end

@config = JoyConfig.new()

cms_uri = URI.parse(@config.cms_uri)

@request = Net::HTTP::Post.new(cms_uri)
@request["Accept"] = "application/json"
@request["Authorization"] = "Bearer " + @config.cms_token unless @config.is_cms_public?
req_options = { use_ssl: cms_uri.scheme == "https", }


@request.body = JSON.dump({"query" => formulate_query})

response = Net::HTTP.start(cms_uri.hostname, cms_uri.port, req_options) do |http|
  http.request(@request)
end

puts response.code
puts response.body
