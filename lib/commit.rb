class Commit
  attr_accessor :subject, :body, :score, :branch_name, :files, :uri, :author
  attr_reader  :id

  def id=(id)
    abort "A commit id must be a String" unless id.is_a?(String)
    @id = id
  end


end
