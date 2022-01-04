require 'yaml'

class JoyConfig
  def initialize(config_file)
    raise ArgumentError.new("Invalid Configuration File") unless File.file?(config_file)
    @config = YAML.load_file(config_file)
    @cms = CMS.new(@config["cms"])
    @score_file = ScoreFile.new(@config["score-file"])
  end

  def cms_uri
    @cms.uri
  end

  def cms_public
    @cms.is_public
  end

  def cms_token
    @cms.token
  end

  def score_file_name
    @score_file.name
  end
end

class CMS
  def initialize(config_entry)
    raise ArgumentError.new("Missing CMS Data") unless config_entry
    @cms = config_entry
  end

  def uri
    @cms["uri"]
  end

  def is_public
    @cms["public"]
  end

  def token
    @cms["token"]
  end
end

class ScoreFile
  DEFAULT_SCORE_FILE = "./TJ_SCORES"

  def initialize(config_entry)
    @score_file = config_entry
  end

  def name
    File.expand_path(File.dirname(__FILE__)) + "/" + raw_file_name
  end

  def raw_file_name
    return DEFAULT_SCORE_FILE if !@score_file
    @score_file["path"] || DEFAULT_SCORE_FILE
  end
end
