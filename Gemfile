source 'http://gemcutter.org'

group :runtime do
  # MongoDB driver
  gem 'mongo',     '~> 1.1'
  gem 'bson_ext',  '~> 1.1'

  # ActiveSupport is preffered over Extlib
  gem 'activesupport', '~> 3.0.0', :require => false

  # DataMapper libs
  DM_VERSION = '~> 1.0.2'

  gem 'dm-core',       DM_VERSION
  gem 'dm-aggregates', DM_VERSION
  gem 'dm-migrations', DM_VERSION
end

group :development do
  gem 'rake'
  gem 'rcov'
  gem 'rspec', '~> 1.3'
  gem 'jeweler'
  gem 'yard',      '~> 0.5'
end

group :quality do
  gem 'yardstick', '~> 0.1'
end
