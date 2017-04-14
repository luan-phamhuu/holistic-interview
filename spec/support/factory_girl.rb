module FactoryGirl
  module FactoryName
    def factory_name(klass=nil)
      (klass || described_class).name.underscore.to_sym
    end

    def pass_factory_validations(klass=nil)
      "pass_#{factory_name(klass)}_validations".to_sym
    end
  end
end

RSpec.configure do |config|
  # Quickly use FactoryGirl methods
  config.include FactoryGirl::Syntax::Methods

  config.include FactoryGirl::FactoryName
end
