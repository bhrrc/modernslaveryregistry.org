class YesNoNotExplicitValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if ['Yes', 'No', 'Not Explicit'].include? value
    record.errors[attribute] << "can't be blank"
  end
end
