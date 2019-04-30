#!/usr/bin/env ruby

file_arg = ARGV[0]
# current_user = ENV['USER']


class CheckCommit
  def check(commit_file)
    puts "Checking Commit Message in (#{commit_file})"
  end
end


check = CheckCommit.new
check.check(file_arg)


