require 'json'

class GitCommit
  def commit_hash
    @commit_hash ||= log_details["id"]
  end

  def short_commit_hash
    @short_commit_hash ||= log_details["shortId"]
  end

  def author_name
    @author_name ||= log_details["authorName"]
  end

  def committer_name
    @committer_name ||= log_details["committerName"]
  end

  def committer_email
    @committer_email ||= log_details["committerEmail"]
  end

  def subject
    @subject ||= log_details["subject"]
  end

  def body
    @body ||= log_details["body"]
  end

  def files
    @files ||= log_details["files"]
  end

  def branch_name
    @git_branch ||= run_command('git branch --show-current')
  end

  def git_location
    @git_location ||= run_command("git config --get remote.origin.url")
  end

  def https_location
      @https_location ||= git_location.gsub(/.*(\@|\/\/)(.*)(\:|\/)([^:\/]*)\/([^\/\.]*)\.git/, 'https://\2/\4/\5/')
  end

  def score
    @score ||= load_score
  end

  def commit_files
     @commit_files ||= multi_line_to_array(run_command('git diff --name-only HEAD~1'))
  end

  def cli_runner=(runner)
    @cli_runner = runner
  end

  private
  def cli_runner
    @cli_runner ||= CliRunner.new
  end

  def encode_returns(input)
    input.split("\n").join('\\n')
  end

  def multi_line_to_array(input)
    input.split(/\n+|\r+/).reject(&:empty?)
  end

  def log_details
    unless @log_details
      details ||= run_command('git log -1 HEAD --format=format:"{\"id\":\"%H\",\"shortId\":\"%h\",\"authorName\":\"%an\",\"committerName\":\"%cn\",\"committerEmail\":\"%ce\",\"subject\":\"%s\",\"body\":\"%b\"}"')
      @log_details = JSON.parse(encode_returns(details))
      @log_details.store("files", commit_files)
    end
    @log_details
  end

  def load_score
    dirname = File.expand_path(File.dirname(__FILE__))
    file = File.read("#{dirname}/TJ_SCORES")
    scores = JSON.parse(file)

    puts "******** SCORES FROM FILE in #{dirname}: #{scores}"
    return scores[subject] || 0
  end

  def run_command(command)
    cli_runner.run(command)
  end
end

class CliRunner
  def run(command)
    %x[#{command}].chomp
  end
end
