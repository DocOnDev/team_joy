require_relative 'code_helpers'

class Author < CodeHelpers::FieldValidations
  string_accessor :name
  email_accessor :email
  initialize_with :name, :email

  def ==(other)
    self.name  == other.name &&
    self.email == other.email
  end

end
