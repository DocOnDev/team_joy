module CodeHelpers
  class FieldValidations
    def self.initialize_with(*field_names)
      define_method("initialize") do |*arguments|
        field_names.each_with_index do |field_name, index|
          raise ArgumentError.new "Field must be declared with an accessor before being used in initialize_with" unless (self.respond_to?"#{field_name}=")
          send("#{field_name}=", arguments[index])
        end
      end
    end

    def self.string_accessor(*field_names)
      type_accessor(String, *field_names)
    end

    def self.int_accessor(*field_names)
      type_accessor(Integer, *field_names)
    end

    def self.int_range_accessor(low, high, *field_names)
      int_accessor(*field_names)
      field_names.each do |field_name|
        define_method("#{field_name}_validation") do |argument|
          raise ArgumentError.new "A #{self.class.name} #{field_name} must be within the range #{low} - #{high}" unless argument.between?(low, high)
        end
      end
    end

    def self.email_accessor(*field_names)
      string_accessor(*field_names)
      field_names.each do |field_name|
        define_method("#{field_name}_validation") do |argument|
          email_format = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
          raise ArgumentError.new "A #{self.class.name} #{field_name} must be a valid email" if (argument =~ email_format).nil?
        end
      end
    end

    def self.type_accessor(class_type, *field_names)
      field_names.each do |field_name|
        make_getter(field_name)
        make_setter(field_name, class_type)
      end
    end

    def self.make_getter(field_name)
      define_method(field_name) do
        instance_variable_get("@#{field_name}")
      end
    end

    def self.make_setter(field_name, class_type)
      define_method("#{field_name}=") do |argument|
        raise ArgumentError.new "A #{self.class.name} #{field_name} must be of type #{class_type.name}" unless argument.is_a?(class_type)
        send("#{field_name}_validation", argument) if self.respond_to?("#{field_name}_validation")
        instance_variable_set("@#{field_name}", argument)
      end
    end
  end
end
