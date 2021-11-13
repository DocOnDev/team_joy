require 'net/http'
require 'uri'
require 'json'
require 'yaml'
# require File.dirname(File.expand_path(__FILE__)) + '/git_commit'

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

  def branch_hash
    @git_branch_hash ||= run_command("git rev-parse %s" % branch_name)
  end

  def git_location
    @git_location ||= run_command("git config --get remote.origin.url")
  end

  def https_location
      @https_location ||= git_location.gsub(/.*(\@|\/\/)(.*)(\:|\/)([^:\/]*)\/([^\/\.]*)\.git/, 'https://\2/\4/\5/')
  end

  def commit_files
     @commit_files ||= multi_line_to_array(run_command('git diff --name-only HEAD~1'))
  end

  private
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

  def run_command(command)
    CliRunner.run(command)
  end
end

class CliRunner
  def self.run(command)
    %x[#{command}].chomp
  end
end


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


# Random is to make each test unique - do not use in production
# commit_id = gitCommit.branch_hash + rand(10..1000).to_s
commit_id = gitCommit.branch_hash
subject = gitCommit.subject
committer_email = gitCommit.committer_email
https_location = gitCommit.https_location
branch_hash = gitCommit.branch_hash

query = 'mutation makeCommit {
  createCommit (data: {
    commitMessage: "'+ subject +'"
    score: 1
    repoCommitId: "'+ commit_id +'"
    repository: {
        connect: { uri: "'+ https_location +'"}
      }
    authors: {
      connect: { email: "'+ committer_email +'" }
    }
  }) { id }
    publishCommit(where: {repoCommitId: "'+ commit_id +'"} to: PUBLISHED) { id }
}
'

#Made hook executable

uri = URI.parse(@config['cms']['uri'])

@request = Net::HTTP::Post.new(uri)
@request["Accept"] = "application/json"
@request["Authorization"] = "Bearer " + @config['cms']['token'] unless @config['cms']['public']
req_options = { use_ssl: uri.scheme == "https", }

@request.body = JSON.dump({"query" => query})

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(@request)
end

puts response.code
puts response.body
