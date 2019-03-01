package Test::Class::Date::Holidays::NZ;

use strict;
use warnings;
use Test::More; # diag
use Env qw($TEST_VERBOSE);

use base qw(Test::Class::Date::Holidays::Base);

our $VERSION = '1.18';

sub setup : Test(setup => 2) {
    my $self = shift;

    if ($TEST_VERBOSE) {
        diag('Running setup for Test::Class::Date::Holidays::NZ');
    }

    # Asserting that our adaptee can what we expect or not
    can_ok('Date::Holidays::NZ', qw(nz_holidays is_nz_holiday));

    $self->{countrycode} = 'NZ';

    my $countrycode = $self->{countrycode};

    ok( my $dh = Date::Holidays->new( countrycode => $countrycode ),
        "Testing contructor with parameter country code: »$countrycode«" );

    $self->{dh} = $dh;

    return 1;
}

sub test_holidays_method_no_parameter : Tests(0) {
    my $self = shift;

    diag('holidays method is not supported by Date::Holidays::NZ');

    return 1;
}

1;
