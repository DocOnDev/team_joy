#!/usr/bin/env ruby

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
    content = File.readlines commit_file
    return ExitCodes.success unless rating_not_found?(content)
    abort "Commit rejected: Message #{content} does not contain a rating between 0 and 5."
  end

  private

  def rating_not_found?(content)
    content.grep(/\-[0-5]\-/).none?
  end

end


if file_arg
  check = CheckCommit.new
  check.check(file_arg)
end