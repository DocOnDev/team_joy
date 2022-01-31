class Author
  attr_accessor :name, :email

  EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  def initialize(name, email)
    validations(name, email)
    @name = name
    @email = email
  end

  def ==(other)
    self.name  == other.name &&
    self.email == other.email
  end

  private

  def validations(name, email)
    raise ArgumentError, 'Name must be a String.' unless name.is_a?(String)
    raise ArgumentError, 'Email must be a String.' unless email.is_a?(String)
    raise ArgumentError, 'Email must have proper format.' if (email =~ EMAIL_FORMAT).nil?
  end
end
