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
    end
  end
end
