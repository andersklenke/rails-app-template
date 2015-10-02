# rails-app-template

## Description
This is the way I like to setup a new Ruby on Rails project. 

## Requirements

This template currently works with:

* Rbenv
* Rails 4.2.x
* PostgreSQL

## Usage
```
rails new blog \
  -m https://raw.githubusercontent.com/andersklenke/rails-app-template/master/template.rb
```

## What will happen?
1. Setup a new Rails project
2. Install gems
3. Setup a Procfile
4. Setup .rubocop.yml
5. Use Postgres instead of SQLLite
6. Removes test directory
7. Setup RSpec
8. Setup Guard
9. rbenv rehash
10. Migrate all databases
11. Install Simpleform (with Bootstrap)
