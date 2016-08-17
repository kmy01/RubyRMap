require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    options = {
      foreign_key: "#{name}_id".to_sym,
      primary_key: :id,
      class_name: name.to_s.camelcase
    }.merge(options)

    @foreign_key = options[:foreign_key]
    @primary_key = options[:primary_key]
    @class_name = options[:class_name]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    options = {
      foreign_key: "#{self_class_name.downcase}_id".to_sym,
      primary_key: :id,
      class_name: name.to_s.singularize.camelcase
    }.merge(options)

    @foreign_key = options[:foreign_key]
    @primary_key = options[:primary_key]
    @class_name = options[:class_name]
  end
end

module Associatable
  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)
    options = assoc_options[name]

    define_method(name) do
      foreign_key_val = self.send(options.foreign_key)
      model_class = options.model_class

      model_class.where(options.primary_key => foreign_key_val).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)

    define_method(name) do
      foreign_key_vals = self.send(options.primary_key)
      model_class = options.model_class

      model_class.where(options.foreign_key => foreign_key_vals)
    end
  end

  def has_one_through(name, through_name, source_name)
    through_options = assoc_options[through_name]
    source_options = through_options.model_class.assoc_options[source_name]

    through_table = through_options.table_name
    through_foreign_key = through_options.foreign_key
    through_primary_key = through_options.primary_key

    source_table = source_options.table_name
    source_foreign_key = source_options.foreign_key
    source_primary_key = source_options.primary_key



    define_method(name) do
      values = self.send(through_foreign_key)
      results = DBConnection.execute(
        "SELECT
          #{source_table}.*
        FROM
          #{through_table}
        JOIN
          #{source_table}
        ON
          #{source_table}.#{through_primary_key} = #{through_table}.#{source_foreign_key}
        WHERE
          #{through_table}.#{through_primary_key} = ?", *values
      )

      source_options.model_class.parse_all(results).first
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class RubyRMap
  extend Associatable
end
