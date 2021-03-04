class ApiController < ApplicationController
  include Api::ExceptionRescue

  class << self
    Swagger::Docs::Generator::set_real_methods

    def inherited(subclass)
      super
      subclass.class_eval do
        setup_basic_api_documentation
      end
    end

    private
    def setup_basic_api_documentation
      %i[index show create update destroy signout].each do |api_action|
        swagger_api api_action do
          param :header, "Authorization", :string, :required, "Authorization Bearer"
        end
      end
    end
  end
end
