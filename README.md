# RubyRMap

## Description

RubyRMap is a lightweight object relational mapping library that can be used with Ruby on Rails. It makes a mapping between model classes to database table names allowing for more abstraction. Models are easily connected with other models through the creation of associations. Below is a snippet of the core functionality of this library.

```Ruby
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

    ...
  end
```

With these two methods users are able to dynamically create new methods that associates one model class with another and vice versa. This is done with the metaprogramming method that is provided by Ruby `define_method`. Inside the define_method, foreign_key values are retrieved by the associated key. A `where` method is used to make an SQL query to database to retrieve all objects associated based on the foreign_key values.

## Getting Started

1. Clone this repo: `git clone https://github.com/kmy01/RubyRMap`

2. Create your SQL file. Reference `pets.sql` for syntax.

3. Create your database file by running `cat filename.sql | filename.db`, where filename is the name of your SQL file.

4. In `lib/db_connection.rb`, edit the following two lines to reflect the sql file and db that you created in step 2 and 3.

  ```Ruby
  SQL_FILE = File.join(ROOT_FOLDER, 'filename.sql')
  DB_FILE = File.join(ROOT_FOLDER, 'filename.db')
  ```

5.  Remember to add `require_relative 'lib/ruby_r_map'` at the top of your files and have your Model classes inherit from `RubyRMap`.

## Libraries Used

- SQLite3
- ActiveSupport::Inflector

## Methods

### Records
- `RubyRMap::all`
- `RubyRMap::find(id)`
- `where(params)`

### Associations
- `belongs_to(name, options_hash)`
- `has_many(name, options_hash)`
- `has_one_through(name, options_hash)`
