module CalendariumRomanum
  module Historical
    # Understands historical sanctorale XML files, can load Sanctorale representing
    # state of the calendar at any specified point of time.
    class SanctoraleLoader
      # @param path [String] path to a XML file with historical sanctorale data
      # @return [CalendariumRomanum::Sanctorale]
      def load_from_file(path, at: :current)
      end
    end
  end
end
