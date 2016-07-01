require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    if instance_variable_get('@columns').nil?
      c = DBConnection.execute2("SELECT * FROM #{table_name}")
      instance_variable_set("@columns", c.first.map { |column| column.to_sym })
    end
    instance_variable_get('@columns')

  end

  def self.finalize!
  end

  def self.table_name=(table_name)
    instance_variable_set("@table_name", table_name)
  end

  def self.table_name
    get = instance_variable_get("@table_name")
    instance_variable_set("@table_name", self.to_s.tableize) if get.nil?
    instance_variable_get("@table_name")
  end

  def self.all
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    # ...
  end

  def attributes
    # ...
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
