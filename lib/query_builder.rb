require_relative 'abstract_interface'

class QueryBuilder
  include AbstractInterface

  needs_implementation :create_commit
end
