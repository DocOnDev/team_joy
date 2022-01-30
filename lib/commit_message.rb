require_relative 'code_helpers'

class CommitMessage < CodeHelpers::DataTypes
  string_accessor :subject, :body
  attr_reader :score

  def initialize
    @subject = ""
    @body = ""
  end

  def score=(score)
    raise ArgumentError.new "A commit score must be of type Integer" unless score.is_a?(Integer)
    raise ArgumentError.new "A commit score must be an Integer between 0 and 5" unless score.between?(0,5)
    @score = score
  end

end
