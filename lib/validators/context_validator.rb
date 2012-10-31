class ContextValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless record.context.match(/#{record.word.entry}/)
      record.errors(attribute, "Context must contain word.")
    end
  end
end
