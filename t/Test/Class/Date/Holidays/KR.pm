package Test::Class::Date::Holidays::KR;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class::Date::Holidays::Base);

sub setup : Test(setup => 2) {
    my $self = shift;

    # Asserting that our adaptee can what we expect or not
    can_ok('Date::Holidays::KR', qw(holidays is_holiday));

    $self->{countrycode} = 'KR';

    my $countrycode = $self->{countrycode};

    ok( my $dh = Date::Holidays->new( countrycode => $countrycode ),
        "Testing contructor with parameter country code: »$countrycode«");

    $self->{dh} = $dh;
}

sub test_holidays_method : Tests(0) {
    my $self = shift;

    diag('holidays method is not supported by Date::Holidays::PL');
}

1;
