class CommitQuery
  def initialize(git_commit)
    @git_commit = git_commit
  end

  def create_query
    raise "Cannot record a commit without a commit hash" unless @git_commit.commit_hash

    puts "body: #{@git_commit.body}"
    

    'createCommit (data: {
      repoCommitId: "' + @git_commit.commit_hash + '"
      subject: "' + @git_commit.subject + '"
      body: "' + @git_commit.body + '"
      score: ' + (@git_commit.score || 0).to_s + '
      branch: "' + @git_commit.branch_name + '"
      committedFiles: ' + (@git_commit.files).to_s + '
      repository: {
        connect: { uri: "' + @git_commit.https_location + '"}
      }
      authors: {
        connect: { email: "' + @git_commit.committer_email + '" }
      }
    }) { id }'
  end

  def publish_query
    raise "Cannot record a commit without a commit hash" unless @git_commit.commit_hash

    'publishCommit(where: {repoCommitId: "' + @git_commit.commit_hash + '"} to: PUBLISHED) { id }'
  end
end
