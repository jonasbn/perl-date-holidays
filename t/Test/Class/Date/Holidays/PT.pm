package Test::Class::Date::Holidays::PT;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class::Date::Holidays::Base);

sub setup : Test(setup => 1) {
    my $self = shift;

    # Asserting that our adaptee can what we expect or not
    can_ok('Date::Holidays::PT', qw(holidays is_pt_holiday));

    $self->{countrycode} = 'PT';
}

1;
