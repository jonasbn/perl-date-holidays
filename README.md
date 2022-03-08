# Date::Holidays

[![CPAN version](https://badge.fury.io/pl/Date-Holidays.svg)](http://badge.fury.io/pl/Date-Holidays)
![stability-stable](https://img.shields.io/badge/stability-stable-green.svg)
[![Build Status](https://travis-ci.org/jonasbn/perl-date-holidays.svg?branch=master)](https://travis-ci.org/jonasbn/perl-date-holidays)
[![Coverage Status](https://coveralls.io/repos/github/jonasbn/perl-date-holidays/badge.svg?branch=master)](https://coveralls.io/github/jonasbn/perl-date-holidays?branch=master)
[![License: Artistic-2.0](https://img.shields.io/badge/License-Artistic%202.0-0298c3.svg)](https://opensource.org/licenses/Artistic-2.0)

<!-- MarkdownTOC autoanchor=false -->

<!-- /MarkdownTOC -->

# NAME

Date::Holidays - Date::Holidays::\* adapter and aggregator for all your holiday needs

# VERSION

The documentation describes version 1.31 of Date::Holidays

# FEATURES

- Exposes a uniform interface towards modules in the Date::Holidays::\* namespace
- Inquire whether a certain date is a holiday in a specific country or a set of countries
- Inquire for a holidays for a given year for a specific country or a set of countries
- Overwrite/rename/suppress national holidays with your own calendar

# SYNOPSIS

    use Date::Holidays;

    # Initialize a national holidays using the ISO 3361 country code
    my $dh = Date::Holidays->new(
        countrycode => 'dk'
    );

    # Inquire and get a local name for a holiday if it is a national holiday
    my $holidayname = $dh->is_holiday(
        year  => 2004,
        month => 12,
        day   => 25
    );

    # Inquire and get a set of local names for national holiday in a given country
    my $hashref = $dh->holidays(
        year => 2004
    );

    # Inquire and get local names for a set of countries, where the specific date is a
    # national holiday
    $holidays_hashref = Date::Holidays->is_holiday(
        year      => 2004,
        month     => 12,
        day       => 25,
        countries => ['se', 'dk', 'no'],
    );

    foreach my $country (keys %{$holidays_hashref}) {
        print $holidays_hashref->{$country}."\n";
    }

    # Example of a module with additional parameters
    # Australia is divided into states with local holidays
    # using ISO-3166-2 codes
    my $dh = Date::Holidays->new(
        countrycode => 'au'
    );

    $holidayname = $dh->is_holiday(
        year  => 2004,
        month => 12,
        day   => 25,
        state => 'TAS',
    );

    $hashref = $dh->holidays(
        year => 2004
        state => 'TAS',
    );

    # Another example of a module with additional parameters
    # Great Britain is divided into regions with local holidays
    # using ISO-3166-2 codes
    my $dh = Date::Holidays->new(
        countrycode => 'gb'
    );

    $holidayname = $dh->is_holiday(
        year    => 2014,
        month   => 12,
        day     => 25,
        regions => ['EAW'],
    );

    $hashref = $dh->holidays(
        year    => 2014
        regions => ['EAW'],
    );

# DESCRIPTION

Date::Holidays is an adapters exposing a uniform API to a set of dsitributions
in the Date::Holidays::\* namespace. All of these modules deliver methods and
information on national calendars, but no standardized API exist.

The distributions more or less follow a _de_ _facto_ standard (see: also the generic
adapter [Date::Holidays::Adapter](https://metacpan.org/pod/Date::Holidays::Adapter)), but the adapters are implemented to uniform
this and Date::Holidays exposes a more readable API and at the same time it
provides an OO interface, to these diverse implementations, which primarily
holds a are produceral.

As described below it is recommended that a certain API is implemented (SEE:
**holidays** and **is\_holiday** below), but taking the adapter strategy into
consideration this does not matter, or we attempt to do what we can with what is
available on CPAN.

If you are an module author/CPAN contributor who wants to comply to the suggested,
either look at some of the other modules in the Date::Holidays::\* namespace to get an
idea of the _de_ _facto_ standard or have a look at [Date::Holidays::Abstract](https://metacpan.org/pod/Date::Holidays::Abstract) and
[Date::Holidays::Super](https://metacpan.org/pod/Date::Holidays::Super) - or write me.

In addition to the adapter feature, Date::Holidays also do aggregation, so you
can combine calendars and you can overwrite and redefined existing calendars.

## DEFINING YOUR OWN CALENDAR

As mentioned in the FEATURES section it is possible to create your own local calendar.

This can be done using a [JSON](https://metacpan.org/pod/JSON) file with your local definitions:

    {
        "1501" : "jonasbn's birthday"
    }

This also mean you can overwrite your national calendar:

    {
        "1225" : ""
    }

You can specify either month plus day for a recurring holiday. If you you want to define
a holiday for a specific year, simply extend the date with year:

    {
        "201.1625" : ""
    }

In order for the calendar to be picked up by Date::Holidays, set the environment variable:

    $HOLIDAYS_FILE

This should point to the JSON file.

# SUBROUTINES/METHODS

## new

This is the constructor. It takes the following parameters:

- countrycode (MANDATORY, see below), unique two letter code representing a country name.  Please refer to ISO3166 (or [Locale::Country](https://metacpan.org/pod/Locale::Country))
- nocheck (optional), if set to true the countrycode specified will not be validated against a list of known country codes for existance, so you can build fake holidays for fake countries, I currently use this for test. This parameter might disappear in the future.

The constructor loads the module from Date::Holidays::\*, which matches the
country code and returns a Date::Holidays module with the specified module
loaded and ready to answer to any of the following methods described below, if
these are implemented - of course.

If no countrycode is provided or the class is not able to load a module, nothing
is returned.

    my $dh = Date::Holidays->new(countrycode => 'dk')
        or die "No holidays this year, get back to work!\n";

## holidays

This is a wrapper around the loaded module's **holidays** method if this is
implemented. If this method is not implemented it tries &lt;countrycode>\_holidays.

Takes 3 optional named arguments:

- year, four digit parameter representing year
- state, ISO-3166-2 code for a state

    Not all countries support this parameter

- regions, pointing to a reference to an array of ISO-3166-2 code for regions

    Not all countries support this parameter

    $hashref = $dh->holidays(year => 2007);

## holidays\_dt

This method is similar to holidays. It takes one named argument b&lt;year>.

The result is a hashref just as for **holidays**, but instead the names
of the holidays are used as keys and the values are DateTime objects.

## is\_holiday

This is yet another wrapper around the loaded module's **is\_holiday**
method if this is implemented. Also if this method is not implemented
it tries is\_&lt;countrycode>\_holiday.

Takes 6 optional named arguments:

- year, four digit parameter representing year
- month, 1-12, representing month
- day, 1-31, representing day
- countries (OPTIONAL), a list of ISO3166 country codes
- state, ISO-3166-2 code for a state. Not all countries support this parameter
- regions, pointing to a reference to an array of ISO-3166-2 code for regions. Not all countries support this parameter

is\_holiday returns the name of a holiday is present in the country specified by
the country code provided to the Date::Holidays constructor.

    $name = $dh->is_holiday(year => 2007, day => 24, month => 12);

If this method is called using the class name **Date::Holidays**, all known
countries are tested for a holiday on the specified date, unless the countries
parameter specifies a subset of countries to test.

    $hashref = Date::Holidays->is_holiday(year => 2007, day => 24, month => 12);

In the case where a set of countries are tested the return value from the method
is a hashref with the country codes as keys and the values as the result.

- `undef` if the country has no module or the data could not be obtained
- a name of the holiday if a holiday is present
- an empty string if the a module was located but the day is not a holiday

## is\_holiday\_dt

This method is similar to is\_holiday, but instead of 3 separate arguments it
only takes a single argument, a DateTime object.

Return 1 for true if the object is a holiday and 0 for false if not.

# DEVELOPING A DATE::HOLIDAYS::\* MODULE

There is no control of the Date::Holidays::\* namespace at all, so I am by no
means an authority, but this is recommendations on order to make the modules
in the Date::Holidays more uniform and thereby more usable.

If you want to participate in the effort to make the Date::Holidays::\* namespace
even more usable, feel free to do so, your feedback and suggestions will be
more than welcome.

If you want to add your country to the Date::Holidays::\* namespace, please feel
free to do so. If a module for you country is already present, I am sure the
author would not mind patches, suggestions or even help.

If however you country does not seem to be represented in the namespace, you
are more than welcome to become the author of the module in question.

Please note that the country code is expected to be a two letter code based on
ISO3166 (or [Locale::Country](https://metacpan.org/pod/Locale::Country)).

As an experiment I have added two modules to the namespace,
[Date::Holidays::Abstract](https://metacpan.org/pod/Date::Holidays::Abstract) and [Date::Holidays::Super](https://metacpan.org/pod/Date::Holidays::Super), abstract is attempt
to make sure that the module implements some, by me, expected methods.

So by using abstract your module will not work until it follows the the abstract
layed out for a Date::Holidays::\* module. Unfortunately the module will only
check for the presence of the methods not their prototypes.

[Date::Holidays::Super](https://metacpan.org/pod/Date::Holidays::Super) is for the lazy programmer, it implements the necessary
methods as stubs and there for do not have to implement anything, but your
module will not return anything of value. So the methods need to be overwritten
in order to comply with the expected output of a Date::Holidays::\* method.

The methods which are currently interesting in a Date::Holidays::\* module are:

- is\_holiday

    Takes 3 arguments: year, month, day and returns the name of the holiday as a
    scalar in the national language of the module context in question. Returns
    undef if the requested day is not a holiday.

        Modified example taken from: L<Date::Holidays::DK|https://metacpan.org/pod/Date::Holidays::DK>

        use Date::Holidays::DK;
        my ($year, $month, $day) = (localtime)[ 5, 4, 3 ];

        $year  += 1900;
        $month += 1;
        print "Woohoo" if is_holiday( $year, $month, $day );

        #The actual method might not be implemented at this time in the
        #example module.

- is\_&lt;countrycode>\_holiday

    Same as above.

    This method however should be a wrapper of the above method (or the other way
    around).

- holidays

    Takes 1 argument: year and returns a hashref containing all of the holidays in
    specied for the country, in the national language of the module context in
    question.

    The keys are the dates, month + day in two digits each concatenated.

        Modified example taken from: L<Date::Holidays::PT|https://metacpan.org/pod/Date::Holidays::PT>

        my $h = holidays($year);
        printf "Jan. 1st is named '%s'\n", $h->{'0101'};

        #The actual method might not be implemented at this time in the
        #example module.

- &lt;countrycode>\_holidays

    This method however should be a wrapper of the above method (or the other way
    around).

**Only** **is\_holiday** and **holidays** are implemented in
[Date::Holidays::Super](https://metacpan.org/pod/Date::Holidays::Super) and are required by [Date::Holidays::Abstract](https://metacpan.org/pod/Date::Holidays::Abstract).

## ADDITIONAL PARAMETERS

Some countries are divided into regions or similar and might require additional
parameters in order to give more exact holiday data.

This is handled by adding additional parameters to **is\_holiday** and
**holidays**.

These parameters are left to the module authors descretion and the actual
Date::Holidays::\* module should be consulted.

    Example Date::Holidays::AU

    use Date::Holidays::AU qw( is_holiday );

    my ($year, $month, $day) = (localtime)[ 5, 4, 3 ];
    $year  += 1900;
    $month += 1;

    my ($state) = 'VIC';
    print "Excellent\n" if is_holiday( $year, $month, $day, $state );

# DEVELOPING A DATE::HOLIDAYS::ADAPTER CLASS

If you want to contribute with an adapter, please refer to the documentation in
[Date::Holidays::Adapter](https://metacpan.org/pod/Date::Holidays::Adapter).

# DEVELOPING ON DATE::HOLIDAYS

Date::Holidays is distributed and maintained using [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla)

## RUNNING THE TEST SUITE

The test suite can be executed using

    $ dzil test

The test suite, which attempts lots scenarios does emit a lot of warnings, so it is recommended to suppress `STDERR` by redirecting it to `/dev/null`

    $ dzil test 2> /dev/null

To enable author tests aimed at asserting distribution and code quality in addition to functionality, use the `--author` flag

    $ dzil test --author 2> /dev/null

If you are working on a release, use the `--release` flag

    $ dzil test --release 2> /dev/null

The release flag is implicit for the [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) release command.

# DIAGNOSTICS

- No country code specified

    No country code has been specified.

- Unable to initialize Date::Holidays for country: &lt;countrycode>

    This message is emitted if a given country code cannot be loaded.

# CONFIGURATION AND ENVIRONMENT

As mentioned in the section on defining your own calendar. You have to
set the environment variable:

    $HOLIDAYS_FILE

This environment variable should point to a JSON file containing holiday definitions
to be used by [Date::Holidays::Adapter::Local](https://metacpan.org/pod/Date::Holidays::Local).

# DEPENDENCIES

- [Carp](https://metacpan.org/pod/Carp)
- [DateTime](https://metacpan.org/pod/DateTime)
- [Locale::Country](https://metacpan.org/pod/Locale::Country)
- [Module::Load](https://metacpan.org/pod/Module::Load)
- [TryCatch](https://metacpan.org/pod/TryCatch)
- [Scalar::Util](https://metacpan.org/pod/Scalar::Util)
- [JSON](https://metacpan.org/pod/JSON)
- [File::Slurp](https://metacpan.org/pod/File::Slurp)

## FOR TESTING

- [Test::Class](https://metacpan.org/pod/Test::Class)
- [Test::More](https://metacpan.org/pod/Test::More)
- [FindBin](https://metacpan.org/pod/FindBin)

Please see the `cpanfile` included in the distribution for a complete listing.

# INCOMPATIBILITIES

Currently the following CPAN Date::Holidays distributions are unsupported:

- [Date::Holidays::UK](https://metacpan.org/pod/Date::Holidays::UK) only supports bank holidays until 2007
- [Date::Holidays::UK::EnglandAndWales](https://metacpan.org/pod/Date::Holidays::UK::EnglandAndWales) only supports bank holidays until 2014

Additional issues might be described the specific adapter classes or their respective adaptees.

# BUGS AND LIMITATIONS

Currently we have an exception for the [Date::Holidays::AU](https://metacpan.org/pod/Date::Holidays::AU) module, so the
additional parameter of state is defaulting to 'VIC', please refer to the POD
for [Date::Holidays::AU](https://metacpan.org/pod/Date::Holidays::AU) for documentation on this.

[Date::Holidays::DE](https://metacpan.org/pod/Date::Holidays::DE) and [Date::Holidays::UK](https://metacpan.org/pod/Date::Holidays::UK) does not implement the
**holidays** methods

The adaptee module for [Date::Holidays::Adapter::JP](https://metacpan.org/pod/Date::Holidays::Adapter::JP) is named:
[Date::Japanese::Holiday](https://metacpan.org/pod/Date::Japanese::Holiday), but the adapter class is following the general
adapter naming of Date::Holidays::Adapter::&lt;countrycode>.

The adapter for [Date::Holidays::PT](https://metacpan.org/pod/Date::Holidays::PT), [Date::Holidays::Adapter::PT](https://metacpan.org/pod/Date::Holidays::Adapter::PT) does not
implement the **is\_pt\_holiday** method. The pattern used is an object adapter
pattern and inheritance is therefor not used, it is my hope that I can
make this work with some Perl magic.

# ISSUE REPORTING

Please report any bugs or feature requests using **GitHub**.

- [GitHub Issues](https://github.com/jonasbn/perl-date-holidays/issues)

# TEST COVERAGE

Coverage reports are available via [Coveralls.io](https://coveralls.io/github/jonasbn/perl-date-holidays?branch=master)

[![Coverage Status](https://coveralls.io/repos/github/jonasbn/perl-date-holidays/badge.svg?branch=master)](https://coveralls.io/github/jonasbn/perl-date-holidays?branch=master)

Without the actual holiday implementations installed/available coverage will be very low.

Please see [Task::Date::Holidays](https://metacpan.org/pod/Task::Date::Holidays), which is a distribution, which can help in installing all the wrapped (adapted and aggregated) distributions.

# SEE ALSO

- [Date::Holidays::AT](https://metacpan.org/pod/Date::Holidays::AT)
- [Date::Holidays::Adapter::AT](https://metacpan.org/pod/Date::Holidays::Adapter::AT)
- [Date::Holidays::AU](https://metacpan.org/pod/Date::Holidays::AU)
- [Date::Holidays::Adapter::AU](https://metacpan.org/pod/Date::Holidays::Adapter::AU)
- [Date::Holidays::BR](https://metacpan.org/pod/Date::Holidays::BR)
- [Date::Holidays::Adapter::BR](https://metacpan.org/pod/Date::Holidays::Adapter::BR)
- [Date::Holidays::AW](https://metacpan.org/pod/Date::Holidays::AW)
- [Date::Holidays::Adapter::AW](https://metacpan.org/pod/Date::Holidays::Adapter::AW)
- [Date::Holidays::BY](https://metacpan.org/pod/Date::Holidays::BY)
- [Date::Holidays::Adapter::BY](https://metacpan.org/pod/Date::Holidays::Adapter::BY)
- [Date::Holidays::CA](https://metacpan.org/pod/Date::Holidays::CA)
- [Date::Holidays::CA\_ES](https://metacpan.org/pod/Date::Holidays::CA_ES)
- [Date::Holidays::Adapter::CA\_ES](https://metacpan.org/pod/Date::Holidays::Adapter::CA_ES)
- [Date::Holidays::CN](https://metacpan.org/pod/Date::Holidays::CN)
- [Date::Holidays::Adapter::CN](https://metacpan.org/pod/Date::Holidays::Adapter::CN)
- [Date::Holidays::CZ](https://metacpan.org/pod/Date::Holidays::CZ)
- [Date::Holidays::Adapter::CZ](https://metacpan.org/pod/Date::Holidays::Adapter::CZ)
- [Date::Holidays::DE](https://metacpan.org/pod/Date::Holidays::DE)
- [Date::Holidays::Adapter::DE](https://metacpan.org/pod/Date::Holidays::Adapter::DE)
- [Date::Holidays::DK](https://metacpan.org/pod/Date::Holidays::DK)
- [Date::Holidays::Adapter::DK](https://metacpan.org/pod/Date::Holidays::Adapter::DK)
- [Date::Holidays::ES](https://metacpan.org/pod/Date::Holidays::ES)
- [Date::Holidays::Adapter::ES](https://metacpan.org/pod/Date::Holidays::Adapter::ES)
- [Date::Holidays::FR](https://metacpan.org/pod/Date::Holidays::FR)
- [Date::Holidays::Adapter::FR](https://metacpan.org/pod/Date::Holidays::Adapter::FR)
- [Date::Holidays::GB](https://metacpan.org/pod/Date::Holidays::GB)
- [Date::Holidays::Adapter::GB](https://metacpan.org/pod/Date::Holidays::Adapter::GB)
- [Date::Holidays::KR](https://metacpan.org/pod/Date::Holidays::KR)
- [Date::Holidays::Adapter::KR](https://metacpan.org/pod/Date::Holidays::Adapter::KR)
- [Date::Holidays::KZ](https://metacpan.org/pod/Date::Holidays::KZ)
- [Date::Holidays::Adapter::KZ](https://metacpan.org/pod/Date::Holidays::Adapter::KZ)
- [Date::Holidays::NL](https://metacpan.org/pod/Date::Holidays::NL)
- [Date::Holidays::Adapter::NL](https://metacpan.org/pod/Date::Holidays::Adapter::NL)
- [Date::Holidays::NO](https://metacpan.org/pod/Date::Holidays::NO)
- [Date::Holidays::Adapter::NO](https://metacpan.org/pod/Date::Holidays::Adapter::NO)
- [Date::Holidays::NZ](https://metacpan.org/pod/Date::Holidays::NZ)
- [Date::Holidays::Adapter::NZ](https://metacpan.org/pod/Date::Holidays::Adapter::NZ)
- [Date::Holidays::PL](https://metacpan.org/pod/Date::Holidays::PL)
- [Date::Holidays::Adapter::PL](https://metacpan.org/pod/Date::Holidays::Adapter::PL)
- [Date::Holidays::PT](https://metacpan.org/pod/Date::Holidays::PT)
- [Date::Holidays::Adapter::PT](https://metacpan.org/pod/Date::Holidays::Adapter::PT)
- [Date::Holidays::RU](https://metacpan.org/pod/Date::Holidays::RU)
- [Date::Holidays::Adapter::RU](https://metacpan.org/pod/Date::Holidays::Adapter::RU)
- [Date::Holidays::SK](https://metacpan.org/pod/Date::Holidays::SK)
- [Date::Holidays::Adapter::SK](https://metacpan.org/pod/Date::Holidays::Adapter::SK)
- [Date::Holidays::UK](https://metacpan.org/pod/Date::Holidays::UK)
- [Date::Holidays::Adapter::UK](https://metacpan.org/pod/Date::Holidays::Adapter::UK)
- [Date::Holidays::USFederal](https://metacpan.org/pod/Date::Holidays::USFederal)
- [Date::Holidays::Adapter::USFederal](https://metacpan.org/pod/Date::Holidays::Adapter::USFederal)
- [Date::Japanese::Holiday](https://metacpan.org/pod/Date::Japanese::Holiday)
- [Date::Holidays::Adapter::JP](https://metacpan.org/pod/Date::Holidays::Adapter::JP)
- [Date::Holidays::UA](https://metacpan.org/pod/Date::Holidays::UA)
- [Date::Holidays::Adapter::UA](https://metacpan.org/pod/Date::Holidays::Adapter::UA)
- [Date::Holidays::Adapter](https://metacpan.org/pod/Date::Holidays::Adapter)
- [Date::Holidays::Abstract](https://metacpan.org/pod/Date::Holidays::Abstract)
- [Date::Holidays::Super](https://metacpan.org/pod/Date::Holidays::Super)

# ACKNOWLEDGEMENTS

- @qorron for PR patching the US adapter, resulting in 1.31
- Wesley Schwengle (WATERKIP) author of Date::Holidays::NL and Date::Holidays::AW for reaching out and letting me know of their existance
- Karen Etheridge (ETHER)
- Neil Bowers (NEILB)
- Miquel Ruiz, PR fixing a bug with regions for ES, supporting Data::Holidays::CA\_ES resulting in 1.22
- Denis Boyun, PR introducing Date::Holidays::UA resulting in 1.19
- Mario Minati, for telling me about the states in Date::Holidays::DE resulting in 1.17
- Vladimir Varlamov, PR introducing Date::Holidays::KZ resulting in 1.07
- CHORNY (Alexandr Ciornii), Github issue #10, letting me know I included local/ by accident, resulting in release 1.05
- Vladimir Varlamov, PR introducing Date::Holidays::BY resulting in 1.04
- Joseph M. Orost, bug report resulting in 1.03
- Alexander Nalobin, patch for using of Date::Holidays::RU, 1.01
- Gabor Szabo, patch assisting META data generation
- Florian Merges for feedback and pointing out a bug in Date::Holidays, author of Date::Holidays::ES
- COG (Jose Castro), Date::Holidays::PT author
- RJBS (Ricardo Signes), POD formatting
- MRAMBERG (Marcus Ramberg), Date::Holidays::NO author
- BORUP (Christian Borup), DateTime suggestions
- LTHEGLER (Lars Thegler), Date::Holidays::DK author
- shild on [use.perl.org](http://use.perl.org/comments.pl?sid=28993&cid=43889), CPAN tester
- CPAN testers in general, their work is invaluable
- All of the authors/contributors of Date::Holidays::\* modules

# AUTHOR

Jonas B., (jonasbn) - `<jonasbn@cpan.org>`

# LICENSE AND COPYRIGHT

Date-Holidays and related modules are (C) by Jonas B., (jonasbn)
2004-2022

Date-Holidays and related modules are released under the Artistic License 2.0

Image used on [website](https://jonasbn.github.io/perl-date-holidays/) is under copyright by [Tim Mossholder](https://unsplash.com/photos/C8jNJslQM3A)
