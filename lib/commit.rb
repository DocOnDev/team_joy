require_relative 'code_helpers'
require_relative 'author'

class Commit < CodeHelpers::DataTypes
  string_accessor :id, :subject, :body, :branch_name, :files, :uri
  int_accessor :score
  type_accessor Author, :author
end
