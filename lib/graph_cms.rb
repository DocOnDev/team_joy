working_path = Dir.pwd
require working_path + '/lib/commit_query'
require working_path + '/lib/author_query'

class GraphCMS
  def initialize(git_commit)
    @git_commit = git_commit
  end

  def query
    commit = CommitQuery.new @git_commit
    author = AuthorQuery.new @git_commit
    'mutation {
      ' + author.upsert_query + '
      ' + author.publish_query + '
      ' + commit.create_query + '
      ' + commit.publish_query + ' }'
  end
end
