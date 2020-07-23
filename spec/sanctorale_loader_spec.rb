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
end
