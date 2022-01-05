#!/usr/bin/env ruby

require_relative 'git_graph_cms_query'
require_relative 'graph_cms_requestor'

git_graph_query = GitGraphCmsQuery.new()
response = GraphCmsRequestor.execute(git_graph_query.query)

puts response.code
puts response.body
