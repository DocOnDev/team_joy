require 'net/http'
require 'uri'
require 'json'
require 'yaml'
require File.dirname(File.expand_path(__FILE__)) + '/git_commit'

@config = YAML.load_file(File.dirname(File.expand_path(__FILE__)) + '/joy_config.yml')

gitCommit = GitCommit.new

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


uri = URI.parse(@config['cms']['uri'])

@request = Net::HTTP::Post.new(uri)
@request["Accept"] = "application/json"
@request["Authorization"] = "Bearer " + @config['cms']['token'] unless @config['cms']['public']
req_options = { use_ssl: uri.scheme == "https", }

@request.body = JSON.dump({"query" => "QUERY"})

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(@request)
end

puts response.code
puts response.body

"Body: #{response.body}"
