source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# use Rails
gem 'rails', '~> 5.2.3'

# Database
gem 'pg', '>= 0.18', '< 2.0'

# use slim engine
gem 'slim-rails'
gem 'html2slim'

gem 'mini_magick', '~> 4.8'

# use webpacker
gem 'webpacker', git: 'https://github.com/rails/webpacker.git'

# use rails console
gem 'rb-readline'

gem 'faker',          '1.7.3'

gem 'kaminari'

gem 'ransack'

gem "aws-sdk-s3", require: false

# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'


gem 'bootstrap'
gem 'jquery-rails'

gem 'redcarpet', '~> 2.3.0'
gem 'coderay'

# 環境変数
gem 'dotenv-rails'

gem 'recaptcha', require: "recaptcha/rails"

# Twitter Auth認証
gem 'omniauth'
gem 'omniauth-twitter'

gem 'hirb'         # モデルの出力結果を表形式で表示するGem
gem 'hirb-unicode' # 日本語などマルチバイト文字の出力時の出力結果のずれに対応


# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
