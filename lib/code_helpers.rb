module CodeHelpers
  class DataTypes
    def self.string_accessor(field_name)
      define_method(field_name) do
        instance_variable_get("@#{field_name}")
      end

      define_method("#{field_name}=") do |argument|
        raise ArgumentError.new "A #{self.class.name} #{field_name} must be a string" unless argument.is_a?(String)
        instance_variable_set("@#{field_name}", argument)
      end
    end

    def self.int_accessor(field_name)
      define_method(field_name) do
        instance_variable_get("@#{field_name}")
      end

      define_method("#{field_name}=") do |argument|
        raise ArgumentError.new "A #{self.class.name} #{field_name} must be an integer" unless argument.is_a?(Integer)
        instance_variable_set("@#{field_name}", argument)
      end
    end
  end
end
