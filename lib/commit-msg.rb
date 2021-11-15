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
    if rating_found?(content)
      score = strip_score_from_subject(content[0])
      write_to_scores_file("#{dirname}/TJ_SCORES", content[0], score)
      File.write(commit_file, content.join("\n"))
      return ExitCodes.success
    end
    abort "Commit rejected: Message #{content} does not contain a rating between 0 and 5."
  end

  private

  def write_to_scores_file(file_path, subject, score)
    out_file = File.new(file_path, "w")
    out_file.puts('{"'+subject.chomp+'":'+score.to_s+'}')
    out_file.close
  end

  def strip_score_from_subject(subject)
    score = subject.scan(/-(\d)-/).first[0].to_i
    subject.slice!("-#{score}- ")
    return score
  end

  def rating_found?(content)
    content.grep(/\-[0-5]\-/).any?
  end

end


if file_arg
  check = CheckCommit.new
  check.check(file_arg)
end
