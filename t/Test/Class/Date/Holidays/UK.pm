package Test::Class::Date::Holidays::UK;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class::Date::Holidays::Base);

our $VERSION = '1.18';

sub setup : Test(setup => 1) {
    my $self = shift;

    # Asserting that our adaptee can what we expect or not
    can_ok('Date::Holidays::UK', qw(is_uk_holiday));

    $self->{countrycode} = 'uk';

    return 1;
}

sub test_constructor : Tests(0) {
    my $self = shift;

    diag('Date::Holidays::UK is not supported by Date::Holidays please see Date::Holidays::GB');

    return 1;
}

sub test_holidays_method : Tests(0) {
    my $self = shift;

    diag('Date::Holidays::UK is not supported by Date::Holidays please see Date::Holidays::GB');

    return 1;
}

sub test_is_holiday_method : Tests(0) {
    my $self = shift;

    diag('Date::Holidays::UK is not supported by Date::Holidays please see Date::Holidays::GB');

    return 1;
}


1;
