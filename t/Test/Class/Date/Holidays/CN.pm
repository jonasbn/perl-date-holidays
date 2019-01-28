package Test::Class::Date::Holidays::CN;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class::Date::Holidays::Base);

sub setup : Test(setup => 1) {
    my $self = shift;

    # Asserting that our adaptee CNn what we expect or not
    can_ok('Date::Holidays::CN', qw(cn_holidays is_cn_holiday));

    $self->{countrycode} = 'CN';
}

1;
