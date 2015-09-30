require "fileutils"
require "shellwords"

# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    source_paths.unshift(tempdir = Dir.mktmpdir("rails-app-template-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git :clone => [
      "--quiet",
      "https://github.com/andersklenke/rails-app-template.git",
      tempdir
    ].map(&:shellescape).join(" ")
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

add_template_repository_to_source_path

template "Gemfile.tt", :force => true

template "Procfile.tt"
template "ruby-version.tt", ".ruby-version"
copy_file "rubocop.yml", ".rubocop.yml"
copy_file "env.tt", ".env"

remove_file "README.rdoc"
copy_file "gitignore", ".gitignore", :force => true

apply "app/template.rb"
apply "config/template.rb"

# Remove test directory and setup Rspec
remove_file "test"
run "rails generate rspec:install"
apply "spec/template.rb"

# Guard
run "guard init rspec"

# Rbenv
run  "rbenv rehash"
run  "bundle install"
run  "rbenv rehash"

# Setup database
run  "bin/rake db:create:all"
run  "bin/rake db:migrate"

# Setup Simple Form with Bootstrap
run "rails generate simple_form:install --bootstrap"