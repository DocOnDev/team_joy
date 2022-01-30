require_relative 'code_helpers'

class Commit < CodeHelpers::DataTypes
  attr_accessor :files, :uri, :author
  string_accessor :id
  string_accessor :subject
  string_accessor :body
  string_accessor :branch_name
  int_accessor :score
end
