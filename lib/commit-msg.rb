#!/usr/bin/env ruby

file_arg = ARGV[0]
# current_user = ENV['USER']

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
    if File.readlines(commit_file).grep(/\-\d\-/).any?
      return ExitCodes.success
    end
    ExitCodes.fail
  end
end


if file_arg
  check = CheckCommit.new
  check.check(file_arg)
end