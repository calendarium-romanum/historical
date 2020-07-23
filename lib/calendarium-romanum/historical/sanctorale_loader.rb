module CalendariumRomanum
  module Historical
    # Understands historical sanctorale XML files, can load Sanctorale representing
    # state of the calendar at any specified point of time.
    class SanctoraleLoader
      # @param src [String] XML document
      # @return [CalendariumRomanum::Sanctorale]
      def load(src, dest = nil, at: :current)
        dest ||= Sanctorale.new

        Nokogiri::XML(src).xpath('/calendar/body/celebration').each do |cel|
          date = cel.xpath('./date[1]').first
          adate = CR::AbstractDate.new date['month'].to_i, date['day'].to_i
          celebration = Celebration.new cel.xpath('./title').text, CR::Ranks[cel.xpath('./rank').text.to_f], CR::Colours::WHITE, cel['symbol'].to_sym, adate

          dest.add adate.month, adate.day, celebration
        end

        dest
      end

      alias load_from_string load

      # @param path [String] path to a XML file with historical sanctorale data
      # @return [CalendariumRomanum::Sanctorale]
      def load_from_file(path, dest = nil, encoding = 'utf-8', at: :current)
        load File.open(path, 'r', encoding: encoding), dest, at: at
      end
    end
  end
end
