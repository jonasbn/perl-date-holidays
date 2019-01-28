package Test::Class::Date::Holidays::KZ;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class::Date::Holidays::Base);

sub setup : Test(setup => 1) {
    my $self = shift;

    # Asserting that our adaptee can what we expect or not
    can_ok('Date::Holidays::KZ', qw(holidays is_kz_holiday));

    $self->{countrycode} = 'KZ';
}

1;
