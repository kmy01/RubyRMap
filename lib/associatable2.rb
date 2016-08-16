require_relative 'associatable'

module Associatable
  def has_one_through(name, through_name, source_name)
    through_options = assoc_options[through_name]
    source_options = through_options.model_class.assoc_options[source_name]

    define_method(name) do
      through_foreign_key_val = self.send(through_options.foreign_key)
      through_primary_key = through_options.primary_key
      through_class = through_options.model_class

      source_obj = through_class.where(
        through_primary_key => through_foreign_key_val
      ).first

      source_foreign_key_val = source_obj.send(source_options.foreign_key)
      source_primary_key = source_options.primary_key
      source_class = source_options.model_class

      source_class.where(
        source_primary_key => source_foreign_key_val
      ).first
    end
  end
end
