require_relative 'joy_config'

Dir.glob(File.expand_path("./*_query_requestor.rb", File.dirname(__FILE__))).each do |file|
  require file
end

class QueryRequestorSelector

  def self.with_config(config)
    @config = config
    return self
  end

  def self.select
    config = @config || JoyConfig.new
    Object.const_get("#{config.cms_type}QueryRequestor").new
  end
end
