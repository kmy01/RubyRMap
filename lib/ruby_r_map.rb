require_relative 'db_connection'
require 'active_support/inflector'

class RubyRMap
  def self.columns
    @columns ||= DBConnection.execute2("SELECT * FROM #{table_name}")
      .first.map { |column| column.to_sym }
  end

  def self.finalize!
    self.columns.each do |column|
      define_method(column) { attributes[column] }
      define_method("#{column}=") { |arg| attributes[column] = arg}
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    everything = DBConnection.execute("SELECT * FROM #{table_name}")
    self.parse_all(everything)
  end

  def self.parse_all(results)
    results.map { |result| self.new(result)}
  end

  def self.find(id)
    found_data = DBConnection.execute(
      "SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = #{id}"
    ).first

    return self.new(found_data) unless found_data.nil?
    nil
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      unless self.class.columns.include?(attr_name.to_sym)
        raise "unknown attribute '#{attr_name}'"
      end
      self.send("#{attr_name}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |column| self.send(column) }
  end

  def insert
    col_names = self.class.columns.join(', ')
    question_marks = (['?'] * self.class.columns.length).join(', ')
    table_name = self.class.table_name

    DBConnection.execute(
      "INSERT INTO
        #{table_name} (#{col_names})
      VALUES
        (#{question_marks})", *attribute_values
    )

    self.id = DBConnection.last_insert_row_id
  end

  def update
    cols = self.class.columns.map { |col| "#{col} = ?" }.join(', ')
    table_name = self.class.table_name

    DBConnection.execute(
      "UPDATE
        #{table_name}
      SET
        #{cols}
      WHERE
        id = ?", *attribute_values, self.id
    )
  end

  def save
    self.id ? update : insert
  end
end
