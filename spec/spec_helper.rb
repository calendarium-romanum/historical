require 'bundler/setup'

require 'calendarium-romanum/cr'
require 'calendarium-romanum/historical'

module Helpers
  def strip_metadata(sanctorale)
    sanctorale.instance_eval { @metadata = nil }

    sanctorale
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Helpers
end
