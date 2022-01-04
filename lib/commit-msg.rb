#!/usr/bin/env ruby

require_relative 'joy_config'
require_relative 'git_commit-msg_adapter'
require_relative 'commit_message_writer'

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
    config = JoyConfig.new()
    write_to_scores_file(config.score_file_name, message.subject, message.score)
    writer = CommitMessageWriter.new(message)
    writer.write_to_file(commit_file)
    return ExitCodes.success
  end

  private

  def self.write_to_scores_file(file_path, subject, score)
    out_file = File.new(file_path, "w")
    out_file.puts('{"'+subject.chomp+'":'+score.to_s+'}')
    out_file.close
  end

end

if file_arg
  CheckCommit.check(file_arg)
end
