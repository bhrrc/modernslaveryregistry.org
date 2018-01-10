class BooleanValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if [true, false].include? value
    record.errors[attribute] << "can't be blank"
  end
end
