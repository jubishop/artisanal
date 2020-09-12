module Slim
  def self.render(source, binding)
    template = Slim::Template.new(nil, nil, {}) { source }
    return template.render(BindingWrapper.new(binding))
  end

  class BindingWrapper
    def initialize(binding)
      @binding = binding
    end

    def method_missing(method)
      return @binding.local_variable_get(method)
    rescue NameError
      return super
    end

    def respond_to_missing?(method)
      return @binding.local_variable_defined?(method) || super
    end
  end
end
