package Test::Class::Date::Holidays::FR;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class::Date::Holidays::Base);

sub setup : Test(setup => 1) {
    my $self = shift;

    # Asserting that our adaptee can what we expect or not
    can_ok('Date::Holidays::FR', qw(is_fr_holiday));

    $self->{countrycode} = 'FR';
}

sub test_holidays_method : Tests(0) {
    my $self = shift;

    diag('holidays method is not supported by Date::Holidays::FR');
}

sub test_holidays_method_no_parameter : Tests(0) {
    my $self = shift;

    diag('holidays method is not supported by Date::Holidays::FR');
}

1;
