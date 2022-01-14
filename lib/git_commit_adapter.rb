require_relative 'commit'
require_relative 'git_commit'
require_relative 'author'

class GitCommitAdapter
  def self.transform_commit(git_commit=GitCommit.new)
    commit = Commit.new
    commit.id = git_commit.commit_hash
    commit.subject = git_commit.subject
    commit.body = git_commit.body
    commit.score = git_commit.score
    commit.branch_name = git_commit.branch_name
    commit.files = git_commit.files.to_s
    commit.author = Author.new(git_commit.committer_name, git_commit.committer_email)

    return commit
  end
end
