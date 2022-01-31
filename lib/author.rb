require_relative 'code_helpers'

class Author < CodeHelpers::DataTypes
  string_accessor :name
  email_accessor :email

  EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  def initialize(name, email)
    send("name=", name)
    send("email=", email)
  end

  def ==(other)
    self.name  == other.name &&
    self.email == other.email
  end

end
