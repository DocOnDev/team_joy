class Commit
  attr_accessor :body, :score, :branch_name, :files, :uri, :author
  attr_reader  :id, :subject

  def id=(id)
    abort "A commit id must be a String" unless id.is_a?(String)
    @id = id
  end

  def subject=(subject)
    abort "A subject must be a String" unless subject.is_a?(String)
    @subject = subject
  end


end
