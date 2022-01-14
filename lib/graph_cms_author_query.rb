class GraphCmsAuthorQuery
  def initialize(author)
    @author = author
  end

  def upsert
    raise "Cannot record an author without an author email" unless @author.email

    author_email = @author.email
    'upsertAuthor (
      where: {email: "' + author_email + '"}
      upsert: {
        create: { email: "' + author_email + '", name: "' + @author.name + '" }
        update: { email: "' + author_email + '", name: "' + @author.name + '" }
      })
    {id}'
  end

  def publish
    raise "Cannot record an author without an author email" unless @author.email

    'publishAuthor(where: {email: "' + @author.email + '"} to: PUBLISHED) {id}'
  end
end
