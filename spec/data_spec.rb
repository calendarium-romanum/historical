require_relative 'spec_helper'

# Specifies that the included data (as handled by the gem's code) have the contents
# we expect them to.
RSpec.describe 'data' do
  let(:file) { 'data/general-roman-la.xml' }
  let(:loader) { CR::Historical::SanctoraleLoader.new }

  it 'loads the initial version correctly' do
    expect(loader.load_from_file(file, at: :base))
      .to eq CR::Data::GENERAL_ROMAN_LATIN_1969
  end

  it 'loads the current version and it is complete' do
    expect(loader.load_from_file(file, at: Date.today))
      .to eq CR::Data::GENERAL_ROMAN_LATIN
  end
end
