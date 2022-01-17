require_relative 'graph_cms_commit_query'
require_relative 'graph_cms_author_query'

class GraphCmsQueryBuilder

  def create_commit(commit)
    commit_query = GraphCmsCommitQuery.new commit
    author_query = GraphCmsAuthorQuery.new commit.author
    'mutation {
      ' + author_query.upsert + '
      ' + author_query.publish + '
      ' + commit_query.create + '
      ' + commit_query.publish + ' }'
  end
end
