class AuthorQuery
  def initialize(git_commit)
    @git_commit = git_commit
  end

  def upsert_query
    raise "Cannot record an author without an author email" unless @git_commit.committer_email

    author_email = @git_commit.committer_email
    'upsertAuthor (
      where: {email: "' + author_email + '"}
      upsert: {
        create: { email: "' + author_email + '", name: "' + @git_commit.committer_name + '" }
        update: { email: "' + author_email + '", name: "' + @git_commit.committer_name + '" }
      })
    {id}'
  end

  def publish_query
    raise "Cannot record an author without an author email" unless @git_commit.committer_email

    'publishAuthor(where: {email: "' + @git_commit.committer_email + '"} to: PUBLISHED) {id}'
  end
end
