require 'net/http'
require 'uri'
require 'json'

def run_cli(command)
  %x[#{command}]
end

def encode_returns(input)
  input.split("\n").join('\\n')
end

def multi_line_to_array(input)
  input.split(/\n+|\r+/).reject(&:empty?)
end

GIT_LOG_COMMAND = 'git log -1 HEAD --format=format:"{\"id\":\"%H\",\"shortID\":\"%h\",\"authorName\":\"%an\",\"committerName\":\"%cn\",\"subject\":\"%s\",\"body\":\"%b\"}"'
GIT_FILES_COMMAND = 'git diff --name-only HEAD~1'

git_details = run_cli(GIT_LOG_COMMAND)
encoded_details = encode_returns(git_details)
details_json = JSON.parse(encoded_details)

commit_files = run_cli(GIT_FILES_COMMAND)
git_files_array = multi_line_to_array(commit_files)

details_json.store("files", git_files_array)

puts details_json


uri = URI.parse("https://api-us-east-1.graphcms.com/v2/ckvjz9zck625301z063hx5rlj/master")
# bearer_token = "%TOKEN%"
query = "{ commits { commitMessage score repoCommitShortId authors { name email } repository { name uri } repoCommitId files { name: location } } } "

request = Net::HTTP::Post.new(uri)
request["Accept"] = "application/json"
# request["Authorization"] = "Bearer " + bearer_token
request.body = JSON.dump({"query" => query})

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

puts response.code
puts response.body

"Body: #{response.body}"
