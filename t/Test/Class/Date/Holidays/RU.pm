package Test::Class::Date::Holidays::RU;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class::Date::Holidays::Base);

our $VERSION = '1.18';

sub setup : Test(setup => 2) {
    my $self = shift;

    # Asserting that our adaptee can what we expect or not
    can_ok('Date::Holidays::RU', qw(holidays is_ru_holiday));

    $self->{countrycode} = 'RU';

    my $countrycode = $self->{countrycode};

    ok( my $dh = Date::Holidays->new( countrycode => $countrycode ),
        "Testing contructor with parameter country code: »$countrycode«" );

    $self->{dh} = $dh;

    return 1;
}

1;
