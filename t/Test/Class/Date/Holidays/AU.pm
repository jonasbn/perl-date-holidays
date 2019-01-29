package Test::Class::Date::Holidays::AU;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class::Date::Holidays::Base);

sub setup : Test(setup => 1) {
    my $self = shift;

    # Asserting that our adaptee can what we expect or not
    can_ok('Date::Holidays::AU', qw(holidays is_holiday));

    $self->{countrycode} = 'au';
}

sub test_holidays_method_no_parameter : Tests(1) {
    my $self = shift;

    ok($self->{dh}->holidays(),
        "Testing holidays with no parameter for: ". $self->{dh}->{'_inner_class'});
}

1;
