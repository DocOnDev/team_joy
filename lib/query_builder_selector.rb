require_relative 'joy_config'

Dir.glob(File.expand_path("./*_query_builder.rb", File.dirname(__FILE__))).each do |file|
  require file
end

class QueryBuilderSelector

  def self.with_config(config)
    @config = config
    return self
  end

  def self.select
    config = @config || JoyConfig.new
    Object.const_get("#{config.cms_type}QueryBuilder").new
  end
end
