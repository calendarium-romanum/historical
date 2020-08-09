require_relative 'spec_helper'

RSpec.describe 'XSLT templates' do
  let(:xml_path) { File.expand_path('../../data/general-roman-la.xml', __FILE__) }
  let(:xml) { Nokogiri::XML File.read xml_path }
  let(:template) { Nokogiri::XSLT File.read template_path }
  let(:xslt_result) do
    template
      .transform(xml)
      .to_xml(encoding: 'UTF-8')
      .sub(/<\?.*?\?>\s*/, '') # remove XML declaration
  end

  shared_examples 'by XSLT vs. by Historical::SanctoraleLoader' do
    it 'produces data equal to those loaded by Historical::SanctoraleLoader' do
      by_xslt = strip_metadata(CR::SanctoraleLoader.new.load_from_string(xslt_result))
      by_loader = CR::Historical::SanctoraleLoader.new.load_from_file(xml_path, at: date)

      # day-by-day check (for faster identification of problems)
      by_loader.each_day do |date,cels|
        expect(cels).to eq by_xslt[date]
      end

      # check that they are equal as a whole (it's hell to work with the huge unhelpful diff -
      # that's why there is the additional check above)
      expect(by_xslt).to eq by_loader
    end
  end

  describe 'initial.xsl' do
    let(:template_path) { File.expand_path('../../xslt/initial.xsl', __FILE__) }
    let(:date) { Date.new(1969,1,1) }

    include_examples 'by XSLT vs. by Historical::SanctoraleLoader'
  end

  describe 'final.xsl' do
    let(:template_path) { File.expand_path('../../xslt/final.xsl', __FILE__) }
    let(:date) { Date.today }

    include_examples 'by XSLT vs. by Historical::SanctoraleLoader'
  end
end
