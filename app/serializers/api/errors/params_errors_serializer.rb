class Api::Errors::ParamsErrorsSerializer < Api::Errors::BaseErrorsSerializer
  I18N_SCOPE = [:params_exception].freeze
  attr_reader :error_type

  def errors
    [{code: code, message: message}]
  end

  private
  def code
    error_type[:code]
  end

  def message
    error_type[:message]
  end

  def class_name_underscore
    object.class.name.underscore.gsub(%r{\/}, ".")
  end
end
