#!/usr/bin/env ruby

# working_path = Dir.pwd
# require working_path + '/lib/git_commit'

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
    dirname = File.expand_path(File.dirname(__FILE__))

    puts "Checking Commit Message in (#{commit_file})"
    content = File.readlines commit_file
    if !rating_not_found?(content)
      file_path = "#{dirname}/TJ_SCORES"
      out_file = File.new(file_path, "w")
      out_file.puts("write your stuff here")
      out_file.close
      return ExitCodes.success
    end
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
