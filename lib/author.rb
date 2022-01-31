require_relative 'code_helpers'

class Author < CodeHelpers::FieldValidations
  string_accessor :name
  email_accessor :email

  def initialize(name, email)
    send("name=", name)
    send("email=", email)
  end

  def ==(other)
    self.name  == other.name &&
    self.email == other.email
  end

end
