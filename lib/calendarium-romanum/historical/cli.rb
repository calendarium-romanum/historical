require 'thor'

module CalendariumRomanum
  module Historical

    # Implementation of the +calendariumromhist+ executable.
    # _Not_ loaded by default when you +require+ the gem.
    #
    # @api private
    class CLI < Thor
      desc 'bootstrap FILE',
           'takes a conventional sanctorale data file, generates initial "historical" XML'
      def bootstrap(data_file)
        sanctorale = CalendariumRomanum::SanctoraleLoader.new.load_from_file(data_file)
        puts SanctoraleXmlGenerator.new.call sanctorale
      end

      desc 'export FILE', 'takes a "historical" XML, prints a conventional data file - by default for the current state of the calendar'
      option :date, aliases: :d, desc: 'export calendar valid at a given date'
      option :front_matter, type: :boolean, desc: 'output YAML front matter'
      def export(data_file)
        date = options[:date] ? Date.parse(options[:date]) : :current
        sanctorale = SanctoraleLoader.new.load_from_file(data_file, at: date)
        SanctoraleWriter.new(front_matter: options[:front_matter]).write sanctorale, STDOUT
      end
    end
  end
end
