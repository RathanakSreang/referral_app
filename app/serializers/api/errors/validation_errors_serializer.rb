class Api::Errors::ValidationErrorsSerializer <
      Api::Errors::BaseErrorsSerializer
  def errors
    object.errors.details.map do |field, details|
      details.map.with_index do |err_detail, index|
        Api::Errors::EachValidationErrorSerializer
          .new(object, field, err_detail, object.errors[field][index]).generate
      end
    end.flatten
  end
end
