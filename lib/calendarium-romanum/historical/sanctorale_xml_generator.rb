require 'nokogiri'

module CalendariumRomanum
  module Historical
    class SanctoraleXmlGenerator
      # @param sanctorale [CalendariumRomanum::Sanctorale]
      # @return [String] XML representation of the sanctorale data
      def call(sanctorale)
        builder = Nokogiri::XML::Builder.new do |x|
          x.calendar do
            x.meta do
              x.title sanctorale.metadata['title']
              x.locale sanctorale.metadata['locale']
            end
            x.body do
              sanctorale.each_day do |date,celebrations|
                celebrations.each do |c|
                  x.celebration(symbol: c.symbol) do
                    x.date month: date.month, day: date.day
                    x.title c.title
                    x.rank c.rank.priority
                    x.colour c.colour.symbol if c.colour != Colours::WHITE
                  end
                end
              end
            end
          end
        end

        builder.to_xml
      end
    end
  end
end
