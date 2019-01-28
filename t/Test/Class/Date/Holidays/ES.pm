package Test::Class::Date::Holidays::ES;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class::Date::Holidays::Base);

sub setup : Test(setup => 1) {
    my $self = shift;

    # Asserting that our adaptee can what we expect or not
    can_ok('Date::Holidays::ES', qw(holidays is_es_holiday));

    $self->{countrycode} = 'ES';
}

1;
