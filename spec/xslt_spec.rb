require_relative 'spec_helper'

RSpec.describe 'XSLT templates' do
  let(:xml_path) { File.expand_path('../../data/general-roman-la.xml', __FILE__) }
  let(:xml) { Nokogiri::XML File.read xml_path }
  let(:xslt_result) do
    template
      .transform(xml)
      .to_xml
      .sub(/<\?.*?\?>\s*/, '') # remove XML declaration
  end

  describe 'initial.xsl' do
    let(:template) { Nokogiri::XSLT File.read File.expand_path('../../xslt/initial.xsl', __FILE__) }

    it 'produces the same Sanctorale data as Historical::SanctoraleLoader' do
      by_xslt = strip_metadata(CR::SanctoraleLoader.new.load_from_string(xslt_result))
      by_loader = CR::Historical::SanctoraleLoader.new.load_from_file(xml_path, at: Date.new(1969,1,1))

      # day-by-day check (for faster identification of problems)
      by_loader.each_day do |date,cels|
        expect(cels).to eq by_xslt[date]
      end

      # check that they are equal as a whole (it's hell to work with the huge unhelpful diff -
      # that's why there is the additional check above)
      expect(by_xslt).to eq by_loader
    end
  end
end
