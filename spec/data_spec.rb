require_relative 'spec_helper'

# Specifies that the included data (as handled by the gem's code) have the contents
# we expect them to.
RSpec.describe 'data' do
  let(:file) { 'data/general-roman-la.xml' }
  let(:loader) { CR::Historical::SanctoraleLoader.new }

  it 'loads the initial version correctly' do
    historical = loader.load_from_file(file, at: Date.new(1969,1,1))
    cr_bundled = CR::Data::GENERAL_ROMAN_LATIN_1969.load

    # don't fail on metadata differences
    strip_metadata(historical)
    strip_metadata(cr_bundled)

    expect(historical)
      .to eq cr_bundled
  end

  it 'loads the current version and it is complete' do
    expect(loader.load_from_file(file, at: Date.today))
      .to eq CR::Data::GENERAL_ROMAN_LATIN.load
  end
end
