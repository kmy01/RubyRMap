# RubyRMap

## Description

RubyRMap is a lightweight object relational mapping library that can be used with Ruby on Rails. It makes a mapping between model classes to database table names allowing for more abstraction. Models are easily connected with other models through the creation of associations.

## Getting Started

1. Clone this repo with `git clone https://github.com/kmy01/RubyRMap`

2. Replace pets.sql with your own sql table creation file. Run `cat filename.sql | filename.db` to create your db file (Replace filename with the name of you file).

3. In `lib/db_connection.rb` file, change the arguments for SQL_FILE and DB_FILE constants with the sql and db files you just created.

4. Now you can begin creating you model classes. Simply have your classes inherit from `RubyRMap` and remember to require the library with `require_relative 'lib/ruby_r_map'`.

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
