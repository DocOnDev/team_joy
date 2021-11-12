require 'net/http'
require 'uri'
require 'json'
require 'yaml'

@config = YAML.load_file(File.dirname(File.expand_path(__FILE__)) + '/joy_config.yml')

class GitCommit
  GIT_URI_COMMAND = "git config --get remote.origin.url"
  GIT_LOG_COMMAND = 'git log -1 HEAD --format=format:"{\"id\":\"%H\",\"shortId\":\"%h\",\"authorName\":\"%an\",\"committerName\":\"%cn\",\"committerEmail\":\"%ce\",\"subject\":\"%s\",\"body\":\"%b\"}"'
  GIT_FILES_COMMAND = 'git diff --name-only HEAD~1'
  GIT_CURRENT_BRANCH_COMMAND = 'git branch --show-current'
  GIT_BRANCH_HASH_COMMAND_STUB = "git rev-parse %s"

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
    @git_branch ||= run_command(GIT_CURRENT_BRANCH_COMMAND)
  end

  def branch_hash
    @git_branch_hash ||= run_command(GIT_BRANCH_HASH_COMMAND_STUB % branch_name)
  end

  def git_location
    @git_location ||= run_command(GIT_URI_COMMAND)
  end

  def https_location
      @https_location ||= git_location.gsub(/.*(\@|\/\/)(.*)(\:|\/)([^:\/]*)\/([^\/\.]*)\.git/, 'https://\2/\4/\5/')
  end

  def log_details
    unless @log_details
      details ||= run_command(GIT_LOG_COMMAND)
      @log_details = JSON.parse(encode_returns(details))
      @log_details.store("files", commit_files)
    end
    @log_details
  end

  def commit_files
     @commit_files ||= multi_line_to_array(run_command(GIT_FILES_COMMAND))
  end

  private
  def run_command(command)
    CliRunner.run(command)
  end
end

class CliRunner
  def self.run(command)
    %x[#{command}].chomp
  end
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

gitCommit = GitCommit.new


puts "Query Data: #{gitCommit.log_details}"

QUERY = "mutation { createCommit ( data: #{gitCommit.log_details} ) }"

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
