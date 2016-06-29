require 'factory_girl_rails'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before :suite do
    DatabaseCleaner.start
    begin
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end

end
