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

  shared_examples 'celebration introduction date' do
    it 'does not load celebration introduced after the specified date' do
      s = loader.load_from_file data_path, at: introduced - 1
      expect(s).to be_a CR::Sanctorale
      expect(s).to be_empty
    end

    it 'does load celebration introduced on the specified date' do
      s = loader.load_from_file data_path, at: introduced
      expect(s).to be_a CR::Sanctorale
      expect(s[date][0].symbol).to be symbol
    end

    it 'does load celebration introduced before the specified date' do
      s = loader.load_from_file data_path, at: introduced + 1
      expect(s).to be_a CR::Sanctorale
      expect(s[date][0].symbol).to be symbol
    end
  end

  describe 'handling celebration/@introduced' do
    let(:data_path) { path('introduced_1996.xml') }
    let(:introduced) { Date.new(1996, 7, 20) }
    let(:date) { CR::AbstractDate.new(4, 28) }
    let(:symbol) { :de_montfort }

    include_examples 'celebration introduction date'
  end

  describe 'handling celebration/@ref' do
    # introduction date not in the celebration element, but in a referenced document
    let(:data_path) { path('introduced_ref_document.xml') }
    let(:introduced) { Date.new(2021, 1, 26) }
    let(:date) { CR::AbstractDate.new(7, 29) }
    let(:symbol) { :martha_mary_lazarus }

    include_examples 'celebration introduction date'
  end

  shared_examples 'changes in changes.xml' do
    it 'initial state' do
      s = loader.load_from_file file, at: Date.new(1970, 1, 1)
      expect(s.get(1, 11)[0])
        .to eq CR::Celebration.new('S. Noni, abbatis, fundatoris Ordinis Programatorum (OProg)', CR::Ranks::MEMORIAL_OPTIONAL, CR::Colours::WHITE, :none, CR::AbstractDate.new(1, 11))
    end

    it 'first change' do
      s = loader.load_from_file file, at: Date.new(1986, 5, 1)
      expect(s.get(1, 11)[0])
        .to eq CR::Celebration.new('S. Noni, abbatis', CR::Ranks::MEMORIAL_GENERAL, CR::Colours::WHITE, :none, CR::AbstractDate.new(1, 11))
    end

    it 'second change' do
      s = loader.load_from_file file, at: Date.new(1987, 5, 1)
      expect(s.get(1, 13)[0]) # date changed
        .to eq CR::Celebration.new('S. Noni, abbatis', CR::Ranks::MEMORIAL_GENERAL, CR::Colours::WHITE, :none, CR::AbstractDate.new(1, 13))
    end

    it 'third change' do
      s = loader.load_from_file file, at: Date.new(1990, 7, 30)
      expect(s.get(1, 11)[0])
        .to eq CR::Celebration.new('S. Noni, abbatis', CR::Ranks::MEMORIAL_GENERAL, CR::Colours::RED, :none, CR::AbstractDate.new(1, 11))
    end

    it 'fourth change' do
      s = loader.load_from_file file, at: Date.new(1990, 10, 1)
      expect(s.get(1, 11)[0])
        .to eq CR::Celebration.new('S. Noni, abbatis', CR::Ranks::MEMORIAL_GENERAL, CR::Colours::WHITE, :none, CR::AbstractDate.new(1, 11))
    end
  end

  describe 'celebration/change' do
    let(:file) { path('changes.xml') }
    include_examples 'changes in changes.xml'
  end

  describe 'celebration/change order does not matter, only dates matter' do
    let(:file) { path('changes_shuffled.xml') }
    include_examples 'changes in changes.xml'
  end

  describe 'celebration/change referencing a document' do
    it 'before change' do
      s = loader.load_from_file path('change_ref_document.xml'), at: Date.new(1970, 1, 1)
      expect(s.get(1, 11)[0])
        .to eq CR::Celebration.new('S. Noni, abbatis, fundatoris Ordinis Programatorum (OProg)', CR::Ranks::MEMORIAL_OPTIONAL, CR::Colours::WHITE, :none, CR::AbstractDate.new(1, 11))
    end

    it 'after change' do
      s = loader.load_from_file path('change_ref_document.xml'), at: Date.new(1987, 2, 2)
      expect(s.get(1, 13)[0])
        .to eq CR::Celebration.new('S. Noni, abbatis, fundatoris Ordinis Programatorum (OProg)', CR::Ranks::MEMORIAL_OPTIONAL, CR::Colours::WHITE, :none, CR::AbstractDate.new(1, 13))
    end
  end

  describe 'celebration/removal' do
    it 'does not load celebration after date of removal' do
      s = loader.load_from_file path('changes.xml'), at: Date.new(2001, 5, 6)
      expect(s).to be_empty
    end
  end
end
