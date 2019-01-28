package Test::Class::Date::Japanese::Holiday;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class::Date::Holidays::Base);

sub setup : Test(setup => 1) {
    my $self = shift;

    # Asserting that our adaptee CNn what we expect or not
    can_ok('Date::Japanese::Holiday', qw(is_holiday is_japanese_holiday));

    $self->{countrycode} = 'JP';
}

sub test_holidays_method : Tests(0) {
    my $self = shift;

    diag('holidays method is not supported by Date::Holidays::FR');
}

1;
