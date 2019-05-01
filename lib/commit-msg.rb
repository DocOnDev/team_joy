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
    content = File.readlines commit_file
    if content.grep(/\-\d\-/).any?
      value = get_numerical_response(content)
      value |= 99
      return ExitCodes.success if value.between?(0, 5)
    end
    ExitCodes.fail
  end

  private

  def get_numerical_response(content)
    content[0].match(/\-(.*?)\-/)[1].to_i
  end
end


if file_arg
  check = CheckCommit.new
  check.check(file_arg)
end