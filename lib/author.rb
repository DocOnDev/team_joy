class Author
  attr_accessor :name, :email

  EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  def initialize(name, email)
    validations(name, email)
    @name = name.to_s
    @email = email.to_s
  end

  def ==(other)
    self.name  == other.name &&
    self.email == other.email
  end

  private

  def validations(name, email)
    raise StandardError, 'Email must have proper format.' if (email =~ EMAIL_FORMAT).nil?
  end
end
