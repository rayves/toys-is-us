# When run rspec tests also want to use factory bot
RSpec.configure do |config|
    config.include FactoryBot::Syntax::Methods
end