require_relative 'spec_helper'

# Specifies that the included data (as handled by the gem's code) have the contents
# we expect them to.
RSpec.describe 'data' do
  let(:file) { 'data/general-roman-la.xml' }
  let(:loader) { CR::Historical::SanctoraleLoader.new }

  def without_titles(sanctorale)
    sanctorale.map_celebrations do |celebration|
      celebration.change title: '' # empty string, because Celebration#change uses nil as default value meaning "do not change this property, copy it"
    end
  end

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
    # TODO: it would be desirable for this example to pass also with raw data,
    #   without the need to strip celebration titles
    expect(without_titles(loader.load_from_file(file, at: Date.today)))
      .to eq without_titles(CR::Data::GENERAL_ROMAN_LATIN.load)
  end

  # potentially dangerous edge case: given document removes one celebration and introduces
  # another one on the same date
  describe '2021 change of the memorial of St. Martha' do
    let(:change_date) { Date.new 2021, 1, 26 }
    let(:memorial_date) { CR::AbstractDate.new 7, 29 }

    it 'has St. Martha on the day before' do
      sanctorale = loader.load_from_file(file, at: change_date - 1)

      celebrations = sanctorale[memorial_date]
      expect(celebrations.size).to eq 1
      expect(celebrations[0].symbol).to be :martha
    end

    it 'has St. Martha, Mary and Lazarus from the day of change on' do
      sanctorale = loader.load_from_file(file, at: change_date)

      celebrations = sanctorale[memorial_date]
      expect(celebrations.size).to eq 1
      expect(celebrations[0].symbol).to be :martha_mary_lazarus
    end
  end
end
