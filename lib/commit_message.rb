require_relative 'code_helpers'

class CommitMessage < CodeHelpers::DataTypes
  string_accessor :subject, :body
  int_range_accessor 0,5, :score

  def initialize
    @subject = ""
    @body = ""
  end
end
