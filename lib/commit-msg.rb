#!/usr/bin/env ruby

require 'joy_config'
require 'git_commit-msg_adapter'

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
  def check(commit_file)
    puts "Checking Commit Message in (#{commit_file})"
    message = GitCommitMessageAdapter.message_from_file(commit_file)
    config = JoyConfig.new()
    write_to_scores_file(config.score_file_name, message.subject, message.score)
    File.write(commit_file, message.body)
    return ExitCodes.success
  end

  private

  def write_to_scores_file(file_path, subject, score)
    out_file = File.new(file_path, "w")
    out_file.puts('{"'+subject.chomp+'":'+score.to_s+'}')
    out_file.close
  end

end

if file_arg
  check = CheckCommit.new
  check.check(file_arg)
end
