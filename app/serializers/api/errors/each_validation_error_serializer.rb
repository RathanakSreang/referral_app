class Api::Errors::EachValidationErrorSerializer
  def initialize record, error_field, details, message
    @record = record
    @error_field = error_field
    @details = details
    @message = "#{field} #{message}"
  end

  def generate
    {resource: resource, field: @error_field, code: code, message: @message}
  end

  private

  def resource
    I18n.t(underscored_resource_name, scope: [:api_validation, :resources])
  end

  def field
    I18n.t(underscored_resource_name, scope: [:api_validation, :resources])
  end

  def code
    I18n.t(@details[:error], scope: [:api_validation, :codes])
  end

  def underscored_resource_name
    @record.class.to_s.gsub("::", "").underscore
  end
end
