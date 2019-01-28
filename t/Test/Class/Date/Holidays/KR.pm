package Test::Class::Date::Holidays::KR;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class::Date::Holidays::Base);

sub setup : Test(setup => 1) {
    my $self = shift;

    # Asserting that our adaptee can what we expect or not
    can_ok('Date::Holidays::KR', qw(holidays is_holiday));

    $self->{countrycode} = 'KR';
}

1;
