require_relative 'code_helpers'

class Author < CodeHelpers::DataTypes
  string_accessor :name
  attr_accessor :email

  EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  def initialize(name, email)
    validations(name, email)
    send("name=", name)
    @email = email
  end

  def ==(other)
    self.name  == other.name &&
    self.email == other.email
  end

  private

  def validations(name, email)
    raise ArgumentError, 'Email must be a String.' unless email.is_a?(String)
    raise ArgumentError, 'Email must have proper format.' if (email =~ EMAIL_FORMAT).nil?
  end
end
