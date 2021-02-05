source 'https://rubygems.org'

ruby '2.7.2'

gem 'bootsnap', '>= 1.4.4', require: false
gem 'faker'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.1'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  gem 'annotate'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 4.0.2'
  gem 'rubocop'
  gem 'rubocop-rails'
end

group :test do
  gem "factory_bot_rails"
  gem 'shoulda-matchers', '~> 4.0'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end
