package Test::Class::Date::Holidays::GB;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class::Date::Holidays::Base);

our $VERSION = '1.18';

sub setup : Test(setup => 2) {
    my $self = shift;

    # Asserting that our adaptee can what we expect or not
    can_ok('Date::Holidays::GB', qw(holidays is_gb_holiday));

    $self->{countrycode} = 'GB';

    my $countrycode = $self->{countrycode};

    ok( my $dh = Date::Holidays->new( countrycode => $countrycode ),
        "Testing contructor with parameter country code: »$countrycode«" );

    $self->{dh} = $dh;

    return 1;
}

sub test_holidays_method_no_parameter : Tests(1) {
    my $self = shift;

    diag('holidays method is not supported by Date::Holidays::GB');

    return 1;
}

1;
