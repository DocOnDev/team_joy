require_relative 'query_requestor_selector'
require_relative 'query_builder_selector'
require_relative 'git_commit_adapter'

class PostCommitHandler

  def self.execute
    # Requestor and Builder are from configurable factory
    query_requestor = QueryRequestorSelector.select
    query_builder = QueryBuilderSelector.select

    # Given this is called from a Git Hook, we use the Git Commit Adapter
    commit = GitCommitAdapter.transform_commit

    response = query_requestor.execute(query_builder.create_commit(commit))
  end
end
