package Test::Class::Date::Holidays::GB;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class::Date::Holidays::Base);

sub setup : Test(setup => 1) {
    my $self = shift;

    # Asserting that our adaptee can what we expect or not
    can_ok('Date::Holidays::GB', qw(holidays is_gb_holiday));

    $self->{countrycode} = 'GB';
}

1;
