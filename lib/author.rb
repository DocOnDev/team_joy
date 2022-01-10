class Author
  attr_accessor :name, :email

  def initialize(name, email)
    @name = name
    @email = email
  end

  def ==(other)
    self.name  == other.name &&
    self.email == other.email
  end
end
