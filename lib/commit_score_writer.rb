require_relative 'joy_config'

class GitCommitScoreWriter
  def self.write(message)
    config = JoyConfig.new
    out_file = File.new(config.score_file_name, "w")
    out_file.puts('{"'+message.subject+'":'+message.score.to_s+'}')
    out_file.close
  end

end
