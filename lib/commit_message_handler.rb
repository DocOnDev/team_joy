require_relative 'git_commit-msg_adapter'
require_relative 'commit_score_writer'
require_relative 'commit_message_writer'

class ExitCodes
  def self.fail
    1
  end

  def self.success
    0
  end
end

class GitCommitMessageHandler

  def self.execute(commit_message_file)
    puts "Checking Commit Message in (#{commit_message_file})"
    message = GitCommitMessageAdapter.message_from_file(commit_message_file)

    GitCommitScoreWriter.write(message)
    overwrite_commit_message_file(commit_message_file, message)
    return ExitCodes.success
  end

  def self.overwrite_commit_message_file(file, message)
    message_writer = GitCommitMessageWriter.new(message)
    message_writer.write_to_file(file)
  end
end
