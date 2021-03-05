class ApiController < ApplicationController
  def render_success response_params = {}
    render json: {success: true, data: response_params}
  end

  def render_errors response_params = {}, status = :unprocessable_entity
    render json: {success: false, errors: response_params}, status: status
  end

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
      %i[index show create update destroy signout my_profile].each do |api_action|
        swagger_api api_action do
          param :header, "AccessToken", :string, :required, "AccessToken"
        end
      end
    end
  end
end
