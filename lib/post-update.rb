require 'net/http'
require 'uri'
require 'json'
require 'yaml'

GIT_URI_COMMAND = "git config --get remote.origin.url"

GIT_LOG_COMMAND = 'git log -1 HEAD --format=format:"{\"id\":\"%H\",\"shortID\":\"%h\",\"authorName\":\"%an\",\"committerName\":\"%cn\",\"committerEmail\":\"%ce\",\"subject\":\"%s\",\"body\":\"%b\"}"'
GIT_FILES_COMMAND = 'git diff --name-only HEAD~1'

GIT_CURRENT_BRANCH_COMMAND = 'git branch --show-current'
GIT_BRANCH_HASH_COMMAND_STUB = "git rev-parse %s"

@config = YAML.load_file('./joy_config.yml')

def run_cli(command)
  %x[#{command}]
end

def encode_returns(input)
  input.split("\n").join('\\n')
end

def multi_line_to_array(input)
  input.split(/\n+|\r+/).reject(&:empty?)
end

def format_for_query(hash)
  result = "{"
  hash.each do |key, value|
    result += "#{key}: \"#{value}\", "
  end
  result + "}"
end

git_branch = run_cli(GIT_CURRENT_BRANCH_COMMAND)
git_branch_hash = run_cli(GIT_BRANCH_HASH_COMMAND_STUB % git_branch)

git_location = run_cli(GIT_URI_COMMAND)
git_location = git_location.gsub(/.*(\@|\/\/)(.*)(\:|\/)([^:\/]*)\/([^\/\.]*)\.git/, 'https://\2/\4/\5/')
puts "Git Location #{git_location}"

git_details = run_cli(GIT_LOG_COMMAND)
encoded_details = encode_returns(git_details)
details_json = JSON.parse(encoded_details)

commit_files = run_cli(GIT_FILES_COMMAND)
git_files_array = multi_line_to_array(commit_files)

details_json.store("files", git_files_array)

# {"id"=>"d45d0ba71f7d6aa0d031c691926f5a2060536bd4", "shortID"=>"d45d0ba", "authorName"=>"Doc Norton", "committerName"=>"Doc Norton", "subject"=>"-2- Reconciling lack of commit rating from merge", "body"=>"", "files"=>["lib/commit-msg.py", "lib/commit-msg.py.windows"]}

query_data = format_for_query(details_json)
puts "Query Data: #{query_data}"

QUERY = "mutation { createCommit ( data: #{query_data} ) }"

# mutation makeCommit ($authorEmail: String!, $commitId: String!) {
#   upsertAuthor (
#     where: {email: $authorEmail}
#   	upsert: {
#       create: { email: "test@docondev.com", name: "Created Test Author" }
#       update: { email: "test@docondev.com", name: "Test Author" }
#     }) {
#     id
#   }
#   publishAuthor(where: {email: "test@docondev.com"} to: PUBLISHED) {
#     id
#   }
#   upsertBranch (
#     where: {hash: "branch-hash"}
#   	upsert: {
#       create: {
#         hash: "branch-hash",
#         name: "Fake Branch",
#         repository: {
#           connect: { uri: "https://github.com/DocOnDev/team_joy"}
#         }
#       }
#       update: {
#         hash: "branch-hash",
#         name: "Fake Branch",
#         repository: {
#           connect: { uri: "https://github.com/DocOnDev/team_joy"}
#         }
#       }
#     }
#   ) {
#     id
#   }
#   publishBranch(where:{hash: "branch-hash"} to: PUBLISHED) {
#     id
#   }
#   createCommit (data: {
#     commitMessage: "Another Fake commit message"
#     score: 1
#     repoCommitId: $commitId
#     repository: {
#         connect: { uri: "https://github.com/DocOnDev/team_joy"}
#       }
#     authors: {
#       connect: { email: "test@docondev.com" }
#     }
#     branch: {
#       connect: {hash: "branch-hash"}
#     }
#   }) {
#     id
#   }
#     publishCommit(where: {repoCommitId: $commitId} to: PUBLISHED) {
#     id
#   }
# }

puts "QUERY: #{QUERY}"



uri = URI.parse(@config['cms']['uri'])

@request = Net::HTTP::Post.new(uri)
@request["Accept"] = "application/json"
@request["Authorization"] = "Bearer " + @config['cms']['token'] unless @config['cms']['public']
@request.body = JSON.dump({"query" => QUERY})

req_options = { use_ssl: uri.scheme == "https", }

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(@request)
end

puts response.code
puts response.body

"Body: #{response.body}"
