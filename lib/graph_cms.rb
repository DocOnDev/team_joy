class GraphCMS

  def initialize(git_commit)
    @git_commit = git_commit
  end

  def query
    'mutation { ' + create_commit + publishCommit + ' }'
  end

  private

  def create_commit
    raise "Cannot record a commit with a commit hash" unless @git_commit.commit_hash

    'createCommit (data: {
      repoCommitId: "' + @git_commit.commit_hash + '"
      commitMessage: "' + @git_commit.subject + '"
      score: ' + (@git_commit.score || 0).to_s + '
      repository: {
        connect: { uri: "' + @git_commit.https_location + '"}
      }
      authors: {
        connect: { email: "' + @git_commit.committer_email + '" }
      }

    }) { id }'
  end

  def publishCommit
    'publishCommit(where: {repoCommitId: "' + @git_commit.commit_hash + '"} to: PUBLISHED) { id }'
  end
end
