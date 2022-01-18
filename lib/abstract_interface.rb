module AbstractInterface

  class InterfaceNotImplementedError < NoMethodError
  end

  def self.included(target_class)
    target_class.send(:include, AbstractInterface::Methods)
    target_class.send(:extend, AbstractInterface::Methods)
    target_class.send(:extend, AbstractInterface::ClassMethods)
  end

  module Methods
    def api_not_implemented(target_class, method_name = nil)
      if method_name.nil?
        caller.first.match(/in \`(.+)\'/)
        method_name = $1
      end
      raise AbstractInterface::InterfaceNotImplementedError.new("#{target_class.class.name} needs to implement '#{method_name}' for interface #{self.name}!")
    end
  end

  module ClassMethods
    def needs_implementation(name, *args)
      self.class_eval do
        define_method(name) do |*args|
          self.class.api_not_implemented(self, name)
        end
      end
    end
  end
end
