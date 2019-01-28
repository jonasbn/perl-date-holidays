package Test::Class::Date::Holidays::BY;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class::Date::Holidays::Base);

sub setup : Test(setup => 1) {
    my $self = shift;

    # Asserting that our adaptee can what we expect or not
    can_ok('Date::Holidays::BY', qw(holidays is_by_holiday));

    $self->{countrycode} = 'BY';
}

1;
