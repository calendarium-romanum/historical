# calendarium-romanum-historical

`calendarium-romanum-historical` is a Ruby gem building upon [calendarium-romanum][caro]
and providing support for historically accurate liturgical calendar computations.
The code and data included in the gem will (once they are sufficiently complete)
allow you to accurately compute liturgical calendar for any time in the past since
the liturgical reform of Vatican II.

## Status

pre-alpha - not yet released

## License

Just like `calendarium-romanum`, `calendarium-romanum-historical` is dual-licensed.
Freely choose between GNU/LGPL 3 and MIT.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'calendarium-romanum-historical'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install calendarium-romanum-historical

## Development roadmap

* [ ] history-aware sanctorale data loader
* [ ] data file with complete history of the General Roman Calendar from 1969 to this day
* [ ] formal specification of the XML data format (allowing validation, use in XML editors etc.)
* [ ] database-backed sanctorale data querying
* [ ] history-aware temporale
* [ ] history-aware calendar rules (concerning solemnity transfers, among other things)
* [ ] main types of historical calendars:
  * [ ] calendar for year Y as it looked on date D (ignores the fact that sanctorale data or calendar rules may change during the year, possibly affecting the calendar)
  * [ ] calendar for year Y as it looked on every respective day of the year

## Usage

Look in the `data` directory what historical calendar data look like.

`$ calendariumromhist bootstrap FILE`

will help you transform your conventional `calendarium-romanum` sanctorale data file
to a XML file used to encode historical development of a calendar.
Edit it and specify changes in time (later on there will be documentation describing
how to do that, for now you're left with examples in the `data` and `spec` directories).

Then code like this will create `Sanctorale` representing state of the calendar
at the specified point of time:

```ruby
loader = CalendariumRomanum::Historical::SanctoraleLoader.new

date = Date.new 1990, 3, 27 # any date you wish
sanctorale = loader.load_from_file 'data/general-roman-la.xml', at: date
```

Using the gem's CLI any historical state of the calendar described in a historical
XML data file can be exported as a conventional `calendarium-romanum` sanctorale data file:

```
$ calendariumromhist export data/general-roman-la.xml
$ calendariumromhist export --date=2000-01-01 data/general-roman-la.xml
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

[caro]: http://github.com/igneus/calendarium-romanum
