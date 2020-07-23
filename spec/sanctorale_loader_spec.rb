require_relative 'spec_helper'

RSpec.describe CR::Historical::SanctoraleLoader do
  let(:loader) { described_class.new }

  def path(basename)
    File.expand_path("../example_data/#{basename}", __FILE__)
  end

  it 'loads an empty file' do
    s = loader.load_from_file path 'empty.xml'
    expect(s).to be_a CR::Sanctorale
    expect(s).to be_empty
  end

  it 'loads a simple celebration' do
    s = loader.load_from_file path 'simple.xml'
    expect(s).to be_a CR::Sanctorale
    expect(s.get(1, 2))
      .to eq [CR::Celebration.new('Ss. Basilii Magni et Gregorii Nazianzeni, episcoporum et Ecclesiae doctorum', CR::Ranks::MEMORIAL_GENERAL, CR::Colours::WHITE, :basil_gregory, CR::AbstractDate.new(1, 2))]
  end

  describe 'handling celebration/@introduced' do
    let(:introduced) { Date.new(1996, 7, 20) }
    it 'does not load celebration introduced after the specified date' do
      s = loader.load_from_file path('introduced_1996.xml'), at: introduced - 1
      expect(s).to be_a CR::Sanctorale
      expect(s).to be_empty
    end

    it 'does load celebration introduced on the specified date' do
      s = loader.load_from_file path('introduced_1996.xml'), at: introduced
      expect(s).to be_a CR::Sanctorale
      expect(s.get(4, 28)[0].symbol).to be :de_montfort
    end

    it 'does load celebration introduced before the specified date' do
      s = loader.load_from_file path('introduced_1996.xml'), at: introduced + 1
      expect(s).to be_a CR::Sanctorale
      expect(s.get(4, 28)[0].symbol).to be :de_montfort
    end
  end

  describe 'celebration/change' do
    it 'initial state' do
      s = loader.load_from_file path('changes.xml'), at: Date.new(1970, 1, 1)
      expect(s.get(1, 11)[0])
        .to eq CR::Celebration.new('S. Noni, abbatis, fundatoris Ordinis Programatorum (OProg)', CR::Ranks::MEMORIAL_OPTIONAL, CR::Colours::WHITE, :none, CR::AbstractDate.new(1, 11))
    end

    it 'first change' do
      s = loader.load_from_file path('changes.xml'), at: Date.new(1986, 5, 1)
      expect(s.get(1, 11)[0])
        .to eq CR::Celebration.new('S. Noni, abbatis', CR::Ranks::MEMORIAL_GENERAL, CR::Colours::WHITE, :none, CR::AbstractDate.new(1, 11))
    end

    it 'second change' do
      s = loader.load_from_file path('changes.xml'), at: Date.new(1987, 5, 1)
      expect(s.get(1, 13)[0]) # date changed
        .to eq CR::Celebration.new('S. Noni, abbatis', CR::Ranks::MEMORIAL_GENERAL, CR::Colours::WHITE, :none, CR::AbstractDate.new(1, 13))
    end

    it 'third change' do
      s = loader.load_from_file path('changes.xml'), at: Date.new(1990, 7, 30)
      expect(s.get(1, 11)[0])
        .to eq CR::Celebration.new('S. Noni, abbatis', CR::Ranks::MEMORIAL_GENERAL, CR::Colours::RED, :none, CR::AbstractDate.new(1, 11))
    end

    it 'fourth change' do
      s = loader.load_from_file path('changes.xml'), at: Date.new(1990, 10, 1)
      expect(s.get(1, 11)[0])
        .to eq CR::Celebration.new('S. Noni, abbatis', CR::Ranks::MEMORIAL_GENERAL, CR::Colours::WHITE, :none, CR::AbstractDate.new(1, 11))
    end
  end

  describe 'celebration/change order does not matter, only dates matter'

  describe 'celebration/removal' do
    it 'does not load celebration after date of removal' do
      s = loader.load_from_file path('changes.xml'), at: Date.new(2001, 5, 6)
      expect(s).to be_empty
    end
  end
end
