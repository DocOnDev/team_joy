#!/usr/bin/env ruby

require_relative 'joy_config'
require_relative 'git_commit-msg_adapter'
require_relative 'commit_message_writer'
require_relative 'commit_score_writer'

file_arg = ARGV[0]

class ExitCodes
  def self.fail
    1
  end

  def self.success
    0
  end
end

class CheckCommit

  def self.check(commit_file)
    puts "Checking Commit Message in (#{commit_file})"
    message = GitCommitMessageAdapter.message_from_file(commit_file)
    CommitScoreWriter.write(message)
    message_writer = CommitMessageWriter.new(message)
    message_writer.write_to_file(commit_file)
    return ExitCodes.success
  end
end

if file_arg
  CheckCommit.check(file_arg)
end
