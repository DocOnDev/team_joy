#!/usr/bin/env ruby

require_relative 'git_graph_cms_query'
require_relative 'graph_cms_requestor'

# Pass commit to CommitSaveQuery object
# Pass CommitSaveQuery.graph_cms_query to GraphCmsRequestor

# Create general commit object - GitCommitAdapter
commit = GitCommitAdapter.transform_commit

git_graph_query = GitGraphCmsQuery.new()
response = GraphCmsRequestor.execute(git_graph_query.query)

puts response.code
puts response.body
