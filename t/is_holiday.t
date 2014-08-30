
use strict;
use Module::Load qw(load);
use Test::More;

my $verbose = 0;
my ( $dh, $holidays_hashref );

use lib qw(lib ../lib);
use_ok('Date::Holidays');

SKIP: {
    eval { load Date::Holidays::DK };
    skip "Date::Holidays::DK not installed", 7 if ($@);

    eval { load Date::Holidays::SE };
    skip "Date::Holidays::SE not installed", 7 if ($@);

    $dh = Date::Holidays->new( countrycode => 'dk' );

    isa_ok( $dh, 'Testing Date::Holidays object' );

    ok( $dh->is_holiday(
            year  => 2004,
            month => 12,
            day   => 25
        ),
        'Testing whether 1. christmas day is a holiday in DK'
    );

    ok( $holidays_hashref = $dh->is_holiday(
            year      => 2004,
            month     => 12,
            day       => 25,
            countries => [ 'no', 'dk' ],
        ),
        'Testing whether 1. christmas day is a holiday in NO and DK'
    );

    is( keys %{$holidays_hashref},
        2, 'Testing to see if we got two definitions' );

    foreach my $country ( keys %{$holidays_hashref} ) {
        if ( $holidays_hashref->{$country} ) {
            print STDERR "$country = " . $holidays_hashref->{$country} . "\n"
                if $verbose;
        }
        ok( $country . 'Testing our specified countries' );
    }

    is( $holidays_hashref->{'dk'}, undef, 'Testing whether DK is set' );
}

ok( $holidays_hashref = Date::Holidays->is_holiday(
        year  => 2004,
        month => 12,
        day   => 25,
    ),
    'Testing is_holiday called without an object'
);

SKIP: {
    eval { load Date::Holidays::PT };
    skip "Date::Holidays::PT not installed", 1 if $@;

    ok( $holidays_hashref->{'pt'},
        'Checking for Portuguese first day of year' );
}

SKIP: {
    eval { load Date::Holidays::AU };
    skip "Date::Holidays::AU not installed", 1 if $@;

    ok( !$holidays_hashref->{'au'},
        'Checking for Australian first day of year' );
}

SKIP: {
    eval { load Date::Holidays::AT };
    skip "Date::Holidays::AT not installed", 1 if $@;

    ok( !$holidays_hashref->{'at'},
        'Checking for Austrian first day of year' );
}

SKIP: {
    eval { load Date::Holidays::ES };
    skip "Date::Holidays::ES not installed", 1 if $@;

    ok( $holidays_hashref->{'es'}, 'Checking for Spanish christmas' );
}

SKIP: {
    eval { load Date::Holidays::NZ };
    skip "Date::Holidays::NZ not installed", 1 if $@;

    ok( !$holidays_hashref->{'nz'}, 'Checking for New Zealandian christmas' );
}

SKIP: {
    eval { load Date::Holidays::NO };
    skip "Date::Holidays::NO not installed", 1 if $@;

    ok( $holidays_hashref->{'no'}, 'Checking for Norwegian christmas' );
}

SKIP: {
    eval { load Date::Holidays::FR };
    skip "Date::Holidays::FR not installed", 1 if $@;

    ok( $holidays_hashref->{'fr'}, 'Checking for French christmas' );
}

SKIP: {
    eval { load Date::Holidays::CN };
    skip "Date::Holidays::CN not installed", 1 if $@;

    ok( $holidays_hashref->{'cn'},
        'Checking for Chinese first day of year' );
}

SKIP: {
    eval { load Date::Holidays::GB };
    skip "Date::Holidays::GB not installed", 1 if $@;

    is( $holidays_hashref->{'gb'}, '', 'Checking for English holiday' );
}

done_testing();
