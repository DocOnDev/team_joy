class CommitMessage
  attr_reader :subject, :score, :body

  def initialize
    @subject = ""
    @body = ""
  end

  def subject=(subject)
    abort "A commit subject must be a String" unless subject.is_a?(String)
    @subject = subject
  end

  def score=(score)
    abort "A commit score must be an Integer" unless score.is_a?(Integer)
    abort "A commit score must be an Integer between 0 and 5" unless score.between?(0,5)
    @score = score
  end

  def body=(body)
    abort "A commit body must be a String" unless body.is_a?(String)
    @body = body
  end
end
