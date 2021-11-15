working_path = Dir.pwd
require working_path + '/lib/commit_query'

class GraphCMS
  def initialize(git_commit)
    @git_commit = git_commit
  end

  def query
    commit = CommitQuery.new @git_commit
    'mutation { ' + commit.create_query + commit.publish_query + ' }'
  end
end
