require_relative 'db_connection'
require_relative 'ruby_r_map'

module Searchable
  def where(params)
    table_name = self.table_name
    where_line = params.keys.map { |attr_name| "#{attr_name} = ? " }.join("AND ")
    found_data = DBConnection
      .execute("SELECT * FROM #{table_name} WHERE #{where_line}", *params.values)
    found_data.map { |data| self.new(data)}
  end
end

class RubyRMap
  extend Searchable
end
