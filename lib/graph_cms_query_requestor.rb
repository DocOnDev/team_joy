require 'net/http'
require 'uri'
require 'json'
require 'yaml'
require_relative 'joy_config'

class GraphCmsQueryRequestor

  def execute(query)
    config = JoyConfig.new()

    cms_uri = URI.parse(config.cms_uri)

    request = Net::HTTP::Post.new(cms_uri)
    request["Accept"] = "application/json"
    request["Authorization"] = "Bearer " + config.cms_token unless config.is_cms_public?
    req_options = { use_ssl: cms_uri.scheme == "https", }

    request.body = JSON.dump({"query" => query})

    response = Net::HTTP.start(cms_uri.hostname, cms_uri.port, req_options) { |http| http.request(request) }

    return response
  end
end
