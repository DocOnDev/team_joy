class GraphCmsCommitQuery
  def initialize(commit)
    @commit = commit
  end

  def create
    raise "Cannot record a commit without a commit id" unless @commit.id

    'createCommit (data: {
      repoCommitId: "' + @commit.id + '"
      subject: "' + @commit.subject + '"
      body: "' + @commit.body + '"
      score: ' + (@commit.score || 0).to_s + '
      branch: "' + @commit.branch_name + '"
      committedFiles: ' + (@commit.files).to_s + '
      repository: {
        connect: { uri: "' + @commit.https_location + '"}
      }
      authors: {
        connect: { email: "' + @commit.committer_email + '" }
      }
    }) { id }'
  end

  def publish
    raise "Cannot record a commit without a commit id" unless @commit.id

    'publishCommit(where: {repoCommitId: "' + @commit.id + '"} to: PUBLISHED) { id }'
  end
end
