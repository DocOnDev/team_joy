class GraphCMS

  def initialize(git_commit)
    @git_commit = git_commit
  end

  def query
    raise "Query requires commit hash" unless @git_commit.commit_hash

    query_string = 'mutation {
      createCommit (data: {
        repoCommitId: "' + @git_commit.commit_hash + '"
      }) { id }
        publishCommit(where: {repoCommitId: "' + @git_commit.commit_hash + '"} to: PUBLISHED) { id }
    }
    '

  end
end
