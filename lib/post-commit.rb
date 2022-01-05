#!/usr/bin/env ruby

require_relative 'graph_cms_query'
require_relative 'graph_cms_requestor'

graph_query = GraphCmsQuery.new()
response = GraphCmsRequestor.execute(graph_query.query)

puts response.code
puts response.body
