#!/usr/bin/env ruby

require_relative 'graph_cms_query'
require_relative 'graph_cms_requestor'

graph_query = GraphCmsQuery.new()
query = graph_query.query

response = GraphCmsRequestor.execute(query)

puts response.code
puts response.body
