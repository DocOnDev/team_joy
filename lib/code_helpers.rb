module CodeHelpers
  class DataTypes
    def self.string_accessor(*field_names)
      type_accessor(String, *field_names)
    end

    def self.int_accessor(*field_names)
      type_accessor(Integer, *field_names)
    end

    def self.type_accessor(class_type, *field_names)
      field_names.each do |field_name|
        define_method(field_name) do
          instance_variable_get("@#{field_name}")
        end

        define_method("#{field_name}=") do |argument|
          raise ArgumentError.new "A #{self.class.name} #{field_name} must be of type #{class_type.name}" unless argument.is_a?(class_type)
          instance_variable_set("@#{field_name}", argument)
        end
      end
    end
  end
end
