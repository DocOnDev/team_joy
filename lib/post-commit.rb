#!/usr/bin/env ruby

require_relative 'git_commit_adapter'
require_relative 'graph_cms_query'
require_relative 'graph_cms_requestor'

commit = GitCommitAdapter.transform_commit

query_builder = GraphCmsQuery.new
create_commit_query = query_builder.create_commit(commit)
response = GraphCmsRequestor.execute(create_commit_query)

puts response.code
puts response.body
