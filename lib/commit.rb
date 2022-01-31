require_relative 'code_helpers'
require_relative 'author'

class Commit < CodeHelpers::FieldValidations
  string_accessor :id, :subject, :body, :branch_name, :files, :uri
  int_range_accessor 0,5, :score
  type_accessor Author, :author
end
