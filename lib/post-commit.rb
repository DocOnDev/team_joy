#!/usr/bin/env ruby

require_relative 'git_commit'
require_relative 'graph_cms_query'
require_relative 'graph_cms_requestor'

def formulate_query()
  git_commit = GitCommit.new
  graph_query = GraphCmsQuery.new(git_commit)
  query = graph_query.query
end

response = GraphCmsRequestor.execute(formulate_query)
puts response.code
puts response.body
