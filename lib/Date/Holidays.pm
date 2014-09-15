package Date::Holidays;

use strict;
use warnings;
use vars qw($VERSION);
use Locale::Country qw(all_country_codes code2country);
use Module::Load qw(load);
use Carp;
use DateTime;
use Error qw(:try);

use Date::Holidays::Exception::AdapterLoad;
use Date::Holidays::Exception::SuperAdapterLoad;
use Date::Holidays::Exception::AdapterInitialization;
use Date::Holidays::Exception::InvalidCountryCode;
use Date::Holidays::Exception::NoCountrySpecified;
use Date::Holidays::Exception::UnsupportedMethod;

use base 'Date::Holidays::Adapter';

$VERSION = '0.22';

sub new {
    my ( $class, %params ) = @_;

    my $self = bless {
        _inner_object => undef,
        _inner_class  => undef,
        _countrycode  => undef,
        },
        ref $class || $class;

    if ( $params{'countrycode'} ) {
        $self->{'_countrycode'} = lc( $params{'countrycode'} );
        try {
            $self->{'_inner_class'}
                = $self->_fetch( { nocheck => $params{'nocheck'}, } );
        }
        catch Date::Holidays::Exception::AdapterLoad with {
            $self = undef;
        }
        catch Date::Holidays::Exception::SuperAdapterLoad with {
            $self = undef;
        };

    } else {
        throw Date::Holidays::Exception::NoCountrySpecified(
            "No country code specified");
    }

    if (   $self
        && $self->{'_inner_class'}
        && $self->{'_inner_class'}->can('new') )
    {
        try {
            my $adapter = $self->{'_inner_class'}->new(
                countrycode => $self->{'_countrycode'},
                nocheck     => $params{'nocheck'},
            );

            if ($adapter) {
                $self->{'_inner_object'} = $adapter;
            } else {
                $self = undef;
            }
        }
        catch Date::Holidays::Exception::AdapterLoad with {
            $self = undef;
        }
        catch Date::Holidays::Exception::AdapterInitialization with {
            $self = undef;
        };

    } elsif ( !$self->{'_inner_class'} ) {
        $self = undef;
    }

    return $self;
}

sub holidays {
    my ( $self, %params ) = @_;

    my $r;
    if ( $self->{'_inner_object'}->can('holidays') ) {
        $r = $self->{'_inner_object'}->holidays( year => $params{'year'}, state => $params{'state'}, regions => $params{'regions'} );
    } else {
        throw Date::Holidays::Adapter::CannotHolidays(
            "Unable to call 'holidays' for: $self->{'_countrycode'}");
    }

    return $r;
}

sub holidays_dt {
    my ( $self, %params ) = @_;

    my $hashref = $self->holidays( year => $params{'year'} );
    my %dts;

    foreach my $h ( keys %{$hashref} ) {
        my ( $month, $day ) = $h =~ m{
            ^(\d{2}) #2 digits indicating the month
            (\d{2})$ #2 digits indicating the day
        }x;
        my $dt = DateTime->new(
            year  => $params{'year'},
            month => $month,
            day   => $day,
        );
        $dts{ $hashref->{$h} } = $dt;
    }

    return \%dts;
}

sub is_holiday {
    my ( $self, %params ) = @_;

    my $r;
    if ( !ref $self ) {

        if ( not $params{'countries'} ) {
            my @countries = all_country_codes();    #from Locale::Country

            @countries = sort @countries;

            $params{'countries'} = \@countries;
        }
        $r = __PACKAGE__->_check_countries(%params);

    } elsif ( $params{'countries'} ) {
        $r = __PACKAGE__->_check_countries(%params);

    } elsif ( $self->{'_countrycode'} ) {

        if (    $self->{'_inner_object'}
            and $self->{'_inner_object'}->can('is_holiday') )
        {

            $r = $self->{'_inner_object'}->is_holiday(
                year  => $params{'year'},
                month => $params{'month'},
                day   => $params{'day'},
                state => $params{'state'},
                regions => $params{'regions'},
            );

        } else {
            throw Date::Holidays::Adapter::CannotIsHoliday(
                "Unable to call 'is_holiday' for: $self->{'_countrycode'}");
        }
    } else {
        throw Date::Holidays::Adapter::NoCalender(
            "No national calendar initialized");
    }

    return $r;
}

sub _check_countries {
    my ( $self, %params ) = @_;

    my %result = ();

    foreach my $country ( @{ $params{'countries'} } ) {

        try {
            my $dh = __PACKAGE__->new( countrycode => $country );

            if ( !$dh ) {
                print STDERR ("Unable to locate module for $country\n");
                return;    #we return instead of using next since we are in
                           #the context of a sub (try)
            }

            my $r = $dh->is_holiday(
                year  => $params{'year'},
                month => $params{'month'},
                day   => $params{'day'}
            );

            if ($r) {
                $result{$country} = $r;
            } else {
                $result{$country} = '';
            }
        }
        catch Date::Holidays::Exception::InvalidCountryCode with {
            my $E = shift;
            print STDERR "$E->{-text}";
            $result{country} = undef;
        }
        catch Date::Holidays::Exception::NoCountrySpecified with {
            my $E = shift;
            print STDERR "$E->{-text}";
            $result{country} = undef;
        }
        catch Date::Holidays::Exception::UnsupportedMethod with {
            my $E = shift;
            print STDERR "$E->{-text}";
            $result{country} = undef;
        };
    }

    return \%result;
}

sub is_holiday_dt {
    my ( $self, $dt ) = @_;

    return $self->is_holiday(
        year  => $dt->year,
        month => $dt->month,
        day   => $dt->day,
    );
}

sub _load {
    my ( $self, $module ) = @_;

    # Trying to load module
    eval { load $module; };    #From Module::Load

    # Asserting success of load
    if ($@) {
        throw Date::Holidays::Exception::SuperAdapterLoad(
            "Unable to load: $module");
    }

    # Returning name of loaded module upon success
    return $module;
}

sub _fetch {
    my ( $self, $params ) = @_;

    # Do we have a country code?
    if ( !$self->{_countrycode} ) {
        throw Date::Holidays::Exception::NoCountrySpecified(
            "No country code specified");
    }

    # Do we do country code assertion?
    if ( !$params->{nocheck} ) {

        # Is our country code valid?
        if ( !code2country( $self->{_countrycode} ) ) {  #from Locale::Country
            throw Date::Holidays::Exception::InvalidCountryCode(
                "$self->{_countrycode} is not a valid country code");
        }
    }

    my $module;

    # Trying to load adapter module for country code
    try {
        $module = 'Date::Holidays::Adapter::' . uc $self->{_countrycode};
        $self->SUPER::_load($module);
    }
    catch Date::Holidays::Exception::AdapterLoad with {

        # Falling over to SUPER adapter class
        try {
            $module = 'Date::Holidays::Adapter';
            $self->_load($module);
        }
        catch Date::Holidays::Exception::SuperAdapterLoad with {
            my $E = shift;
            $E->throw;
        };
    };

    # Returning name of loaded module upon success
    return $module;
}

1;

__END__

=pod

=begin markdown

[![CPAN version](https://badge.fury.io/pl/Date-Holidays.svg)](http://badge.fury.io/pl/Date-Holidays)
[![Build Status](https://travis-ci.org/jonasbn/Date-Holidays.svg?branch=master)](https://travis-ci.org/jonasbn/Date-Holidays)
[![Coverage Status](https://coveralls.io/repos/jonasbn/Date-Holidays/badge.png?branch=master)](https://coveralls.io/r/jonasbn/Date-Holidays?branch=master)

=end markdown

=head1 NAME

Date::Holidays - a Date::Holidays::* OOP Adapter aggregator

=head1 VERSION

This POD describes version 0.22 of Date::Holidays

=head1 SYNOPSIS

    use Date::Holidays;

    my $dh = Date::Holidays->new(
        countrycode => 'dk'
    );

    $holidayname = $dh->is_holiday(
        year  => 2004,
        month => 12,
        day   => 25
    );

    $hashref = $dh->holidays(
        year => 2004
    );


    $holidays_hashref = Date::Holidays->is_holiday(
        year      => 2004,
        month     => 12,
        day       => 25,
        countries => ['se', 'dk', 'no'],
    );

    foreach my $country (keys %{$holidays_hashref}) {
        print $holidays_hashref->{$country}."\n";
    }


    $holidays_hashref = Date::Holidays->is_holiday(
        year      => 2004,
        month     => 12,
        day       => 25,
    );


    #Example of a module with additional parameters
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

    #Another example of a module with additional parameters
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

=head1 DESCRIPTION

Date::Holidays is an aggregator of adapters exposing a uniform API to a set of
modules either in the Date::Holidays::* namespace of elsewhere. All of these
modules deliver methods and information on national calendars.

The module seem to more or less follow a defacto standard (see: also the generic
adapter L<Date::Holidays::Adapter>), but the adapters are implemented to uniform
this and Date::Holidays exposes a more readable API and at the same time it
provides an OOP interface, to these modules, which primarily holds a procuderal
API.

As described below it is recommended that a certain API is implemented (SEE:
B<holidays> and B<is_holiday> below), but taking the adapter strategy into
consideration this does not matter, or we attempt to do what we can with what is
provided.

If you are an author who wants to comply to the suggested, either
look at some of the other modules in the Date::Holidays::* namespace to get an
idea of the de facto standard or have a look at L<Date::Holidays::Abstract> and
L<Date::Holidays::Super> - or write me.

=head1 SUBROUTINES/METHODS

=head2 new

This is the constructor. It takes the following parameters:

=over

=item countrycode (MANDATORY, see below), two letter unique code representing a
country name.  Please refer to ISO3166 (or L<Locale::Country>)

=item nocheck (optional), if set to true the countrycode specified will not be
validated against ISO 3166, for existance, so you can build fake holidays for
fake countries, I currently use this for test.

=back

The constructor loads the module from Date::Holidays::*, which matches the
country code and returns a Date::Holidays module with the specified module
loaded and ready to answer to any of the following methods described below, if
these are implemented - of course.

If no countrycode is provided or the class is not able to load a module, nothing
is returned.

    my $dh = Date::Holidays->new(countrycode => 'dk')
        or die "No holidays this year, get back to work!\n";

=head2 holidays

This is a wrapper around the loaded module's B<holidays> method if this is
implemented. If this method is not implemented it tries <countrycode>_holidays.

Takes 3 optional named arguments:

=over

=item * year, four digit parameter representing year

=item * state, ISO-3166-2 code for a state

Not all countries support this parameter

=item * regions, pointing to a reference to an array of ISO-3166-2 code for regions

Not all countries support this parameter

=back

    $hashref = $dh->holidays(year => 2007);

=head2 holidays_dt

This method is similar to holidays. It takes one named argument b<year>.

The result is a hashref just as for B<holidays>, but instead the names
of the holidays are used as keys and the values are DateTime objects.

=head2 is_holiday

This is yet another wrapper around the loaded module's B<is_holiday>
method if this is implemented. Also if this method is not implemented
it tries is_<countrycode>_holiday.

Takes 6 optional named arguments:

=over

=item * year, four digit parameter representing year

=item * month, 1-12, representing month

=item * day, 1-31, representing day

=item * countries (OPTIONAL), a list of ISO3166 country codes

=item * state, ISO-3166-2 code for a state. Not all countries support this parameter

=item * regions, pointing to a reference to an array of ISO-3166-2 code for regions. Not all countries support this parameter

=back

is_holiday returns the name of a holiday is present in the country specified by
the country code provided to the Date::Holidays constructor.

    $name = $dh->is_holiday(year => 2007, day => 24, month => 12);

If this method is called using the class name B<Date::Holidays>, all known
countries are tested for a holiday on the specified date, unless the countries
parameter specifies a subset of countries to test.

    $hashref = Date::Holidays->is_holiday(year => 2007, day => 24, month => 12);

In the case where a set of countries are tested the return value from the method
is a hashref with the country codes as keys and the values as the result.

=over

=item undef if the country has no module or the data could not be obtained

=item a name of the holiday if a holiday is present

=item an empty string if the a module was located but the day is not a holiday

=back

=head2 is_holiday_dt

This method is similar to is_holiday, but instead of 3 separate arguments it
only takes a single argument, a DateTime object.

Return 1 for true if the object is a holiday and 0 for false if not.

=head1 DEVELOPING A DATE::HOLIDAYS::* MODULE

There is no control of the Date::Holidays::* namespace at all, so I am by no
means an authority, but this is recommendations on order to make the modules
in the Date::Holidays more uniform and thereby more usable.

If you want to participate in the effort to make the Date::Holidays::* namespace
even more usable, feel free to do so, your feedback and suggestions will be
more than welcome.

If you want to add your country to the Date::Holidays::* namespace, please feel
free to do so. If a module for you country is already present, I am sure the
author would not mind patches, suggestions or even help.

If however you country does not seem to be represented in the namespace, you
are more than welcome to become the author of the module in question.

Please note that the country code is expected to be a two letter code based on
ISO3166 (or L<Locale::Country>).

As an experiment I have added two modules to the namespace,
L<Date::Holidays::Abstract> and L<Date::Holidays::Super>, abstract is attempt
to make sure that the module implements some, by me, expected methods.

So by using abstract your module will not work until it follows the the abstract
layed out for a Date::Holidays::* module. Unfortunately the module will only
check for the presence of the methods not their prototypes.

L<Date::Holidays::Super> is for the lazy programmer, it implements the necessary
methods as stubs and there for do not have to implement anything, but your
module will not return anything of value. So the methods need to be overwritten
in order to comply with the expected output of a Date::Holidays::* method.

The methods which are currently interesting in a Date::Holidays::* module are:

=over

=item is_holiday

Takes 3 arguments: year, month, day and returns the name of the holiday as a
scalar in the national language of the module context in question. Returns
undef if the requested day is not a holiday.

    Modified example taken from: L<Date::Holidays::DK>

    use Date::Holidays::DK;
    my ($year, $month, $day) = (localtime)[ 5, 4, 3 ];

    $year  += 1900;
    $month += 1;
    print "Woohoo" if is_holiday( $year, $month, $day );

    #The actual method might not be implemented at this time in the
    #example module.

=item is_<countrycode>_holiday

Same as above.

This method however should be a wrapper of the above method (or the other way
around).

=item holidays

Takes 1 argument: year and returns a hashref containing all of the holidays in
specied for the country, in the national language of the module context in
question.

The keys are the dates, month + day in two digits each concatenated.

    Modified example taken from: L<Date::Holidays::PT>

    my $h = holidays($year);
    printf "Jan. 1st is named '%s'\n", $h->{'0101'};

    #The actual method might not be implemented at this time in the
    #example module.

=item <countrycode>_holidays

This method however should be a wrapper of the above method (or the other way
around).

=back

B<Only> B<is_holiday> and B<holidays> are implemented in
L<Date::Holidays::Super> and are required by L<Date::Holidays::Abstract>.

=head2 ADDITIONAL PARAMETERS

Some countries are divided into regions or similar and might require additional
parameters in order to give more exact holiday data.

This is handled by adding additional parameters to B<is_holiday> and
B<holidays>.

These parameters are left to the module authors descretion and the actual
Date::Holidays::* module should be consulted.

    Example Date::Holidays::AU

    use Date::Holidays::AU qw( is_holiday );

    my ($year, $month, $day) = (localtime)[ 5, 4, 3 ];
    $year  += 1900;
    $month += 1;

    my ($state) = 'VIC';
    print "Excellent\n" if is_holiday( $year, $month, $day, $state );

=head1 DEVELOPING A DATE::HOLIDAYS::ADAPTER CLASS

If you want to contribute with an adapter, please refer to the documentation in
L<Date::Holidays::Adapter>.

=head1 DIAGNOSTICS

=over

=item * L<Date::Holidays::Exception::AdapterLoad>

This exception is thrown when L<Date::Holidays::Adapter> attempts to load an
actual adapter implementation. This exception is recoverable to the extend
that is caught and handled internally.

When caught the SUPER adapter is attempted loaded, L<Date::Holidays::Adapter>
if this however fails L<Date::Holidays::Exception::SuperAdapterLoad> it thrown
see below.

=item * L<Date::Holidays::Exception::SuperAdapterLoad>

This exception is thrown when L<Date::Holidays> attempts to load the
SUPER adapter L<Date::Holidays::Adapter>, if this fail, we are out of luck and
we throw the L<Date::Holidays::Exception::AdapterInitialization> exception.

=item * L<Date::Holidays::Exception::AdapterInitialization>

This exception is thrown when in was not possible to load either a
implementation of a given adapter, or the SUPER adapter
L<Date::Holidays::Adapter>.

=item * L<Date::Holidays::Exception::NoCountrySpecified>

The exception is thrown if a country code is provided, which is not listed
in L<Locale::Country>, which lists ISO 3166 codes, which is the unique 2
letter strings assigned to each country in the world.

=item * 'Unable to locate module for <country>' this method is thrown from
the B<_check_countries> method, it bails out if it cannot find and load the
actual implementation of a module with the name Date::Holidays::<country> for
the specified country. This however is a mere warning.

=back

=head1 CONFIGURATION AND ENVIRONMENT

No special configuration or environment is required.

=head1 DEPENDENCIES

=over

=item * L<Carp>

=item * L<DateTime>

=item * L<Locale::Country>

=item * L<Module::Load>

=item * L<Error>

=item * L<Date::Holidays::Adapter>

=back

=head1 INCOMPATIBILITIES

None known at the moment, please refer to BUGS AND LIMITATIONS and or the
specific adapter classes or their respective adaptees.

=head1 BUGS AND LIMITATIONS

Currently we have an exception for the L<Date::Holidays::AU> module, so the
additional parameter of state is defaulting to 'VIC', please refer to the POD
for L<Date::Holidays::AU> for documentation on this.

L<Date::Holidays::DE> and L<Date::Holidays::UK> does not implement the
B<holidays> methods

The actual code for United Kingdom in ISO 3166 is 'GB' (SEE L<Locale::Country>),
but the module is called L<Date::Holidays::UK> and so it the adapter class
L<Date::Holidays::Adapter::GB> in this distribution to avoid confusion or?

The adaptee module for L<Date::Holidays::Adapter> is named:
L<Date::Japanese::Holiday>, but the adapter class is following the general
adapter naming of Date::Holidays::Adapter::<countrycode>.

The adapter for L<Date::Holidays::PT>, L<Date::Holidays::Adapter::PT> does not
implement the B<is_pt_holiday> method. The pattern used is an object adapter
pattern and inheritance is therefor not used, it is my hope that I can
make this work with some Perl magic.

=head1 BUG REPORTING

Please report issues via CPAN RT:

  http://rt.cpan.org/NoAuth/Bugs.html?Dist=Date-Holidays

or by sending mail to

  bug-Date-Holidays@rt.cpan.org

=head1 TEST COVERAGE

Test coverage in version 0.06

    ---------------------------- ------ ------ ------ ------ ------ ------ ------
    File                           stmt   bran   cond    sub    pod   time  total
    ---------------------------- ------ ------ ------ ------ ------ ------ ------
    blib/lib/Date/Holidays.pm      82.1   68.0   66.7  100.0  100.0  100.0   79.6
    Total                          82.1   68.0   66.7  100.0  100.0  100.0   79.6
    ---------------------------- ------ ------ ------ ------ ------ ------ ------

I am working on a better coverage in future releases

=head1 SEE ALSO

=over

=item * L<Date::Holidays::AU>

=item * L<Date::Holidays::Adapter::AU>

=item * L<Date::Holidays::DE>

=item * L<Date::Holidays::Adapter::DE>

=item * L<Date::Holidays::DK>

=item * L<Date::Holidays::Adapter::DK>

=item * L<Date::Holidays::CN>

=item * L<Date::Holidays::Adapter::CN>

=item * L<Date::Holidays::FR>

=item * L<Date::Holidays::Adapter::FR>

=item * L<Date::Holidays::NO>

=item * L<Date::Holidays::Adapter::NO>

=item * L<Date::Holidays::NZ>

=item * L<Date::Holidays::Adapter::NZ>

=item * L<Date::Holidays::PT>

=item * L<Date::Holidays::Adapter::PT>

=item * L<Date::Holidays::UK>

=item * L<Date::Holidays::Adapter::GB>

=item * L<Date::Holidays::ES>

=item * L<Date::Holidays::Adapter::ES>

=item * L<Date::Japanese::Holiday>

=item * L<Date::Holidays::Adapter::JP>

=item * L<Date::Holidays::Adapter>

=item * L<Date::Holidays::Abstract>

=item * L<Date::Holidays::Super>

=item * L<Date::Holidays::AT>

=item * L<Date::Holidays::CN>

=back

=head1 ACKNOWLEDGEMENTS

=over

=item * Florian Merges for feedback and pointing out a bug in Date::Holidays,
author of Date::Holidays::ES

=item * COG (Jose Castro), Date::Holidays::PT author

=item * RJBS (Ricardo Signes), POD formatting

=item * MRAMBERG (Marcus Ramberg), Date::Holidays::NO author

=item * BORUP (Christian Borup), DateTime suggestions

=item * LTHEGLER (Lars Thegler), Date::Holidays::DK author

=item * shild on use.perl.org, CPAN tester
http://use.perl.org/comments.pl?sid=28993&cid=43889

=item * CPAN testers in general, their work is invaluable

=item * All of the authors/contributors of Date::Holidays::* modules

=back

=head1 AUTHOR

Jonas B. Nielsen, (jonasbn) - C<< <jonasbn@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Date-Holidays and related modules are (C) by Jonas B. Nielsen, (jonasbn)
2004-2014

Date-Holidays and related modules are released under the artistic license

The distribution is licensed under the Artistic License, as specified
by the Artistic file in the standard perl distribution
(http://www.perl.com/language/misc/Artistic.html).

=cut
