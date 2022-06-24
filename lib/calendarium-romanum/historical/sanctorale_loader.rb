module CalendariumRomanum
  module Historical
    # Understands historical sanctorale XML files, can load Sanctorale representing
    # state of the calendar at any specified point of time.
    class SanctoraleLoader
      # @param src [String] XML document
      # @return [CalendariumRomanum::Sanctorale]
      def load(src, dest = nil, at: :current)
        dest ||= Sanctorale.new

        point = :current == at ? Date.today : at

        doc = Nokogiri::XML(src)
        doc.xpath('/calendar/body/celebration').each do |cel|
          introduction_date =
            if cel['introduced']
              Date.parse(cel['introduced'])
            elsif cel['ref']
              document_promulgation_date(cel['ref'], doc)
            end
          next if introduction_date && introduction_date > point

          removed = cel.xpath('./removal')
          next if (!removed.empty?) && promulgation_date(removed.first, doc) <= point

          date = cel.xpath('./date').first

          titlel = cel.xpath('./title')
          rankel = cel.xpath('./rank')
          colourel = cel.xpath('./colour')

          cel.xpath('./change')
            .collect {|ch| [promulgation_date(ch, doc), ch] }
            .sort_by {|promulgated, ch| promulgated }
            .each do |promulgated, ch|
            next if promulgated > point

            date = ch.xpath('./date').first unless ch.xpath('./date').empty?
            titlel = ch.xpath('./title') unless ch.xpath('./title').empty?
            rankel = ch.xpath('./rank') unless ch.xpath('./rank').empty?
            colourel = ch.xpath('./colour') unless ch.xpath('./colour').empty?
          end

          adate = AbstractDate.new date['month'].to_i, date['day'].to_i
          colour = colourel.empty? ? Colours::WHITE : Colours[colourel.text.to_sym]
          celebration = Celebration.new titlel.text, Ranks[rankel.text.to_f], colour, cel['symbol'].to_sym, adate

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

      protected

      def promulgation_date(change, doc)
        if change['promulgated']
          Date.parse(change['promulgated'])
        elsif change['ref']
          document_promulgation_date(change['ref'], doc)
        else
          raise "each `#{change.name}` element must have either @promulgated or @ref attribute"
        end
      end

      def document_promulgation_date(ref, doc)
        document = doc.xpath("/calendar/documents/document[@id = '#{ref}']")

        Date.parse(document.xpath('./promulgated').text)
      end
    end
  end
end
