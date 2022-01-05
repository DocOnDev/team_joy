require_relative 'commit_query'
require_relative 'author_query'
require_relative 'git_commit'

class GitGraphCmsQuery
  def initialize(git_commit=GitCommit.new)
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