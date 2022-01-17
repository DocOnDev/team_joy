#!/usr/bin/env ruby

require_relative 'git_commit_adapter'
require_relative 'query_builder_selector'
require_relative 'graph_cms_requestor'

commit = GitCommitAdapter.transform_commit

query_builder = QueryBuilderSelector.select

create_commit_query = query_builder.create_commit(commit)
response = GraphCmsRequestor.execute(create_commit_query)

puts response.code
puts response.body
