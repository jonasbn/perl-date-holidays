package Test::Class::Date::Holidays::AU;

use strict;
use warnings;
use Test::More;
use Test::Fatal qw(lives_ok);

use base qw(Test::Class::Date::Holidays::Base);

our $VERSION = '1.18';

sub setup : Test(setup => 2) {
    my $self = shift;

    # Asserting that our adaptee can what we expect or not
    can_ok('Date::Holidays::AU', qw(holidays is_holiday));

    $self->{countrycode} = 'au';

    my $countrycode = $self->{countrycode};

    ok( my $dh = Date::Holidays->new( countrycode => $countrycode ),
        "Testing contructor with parameter country code: »$countrycode«" );

    $self->{dh} = $dh;

    return 1;
}

sub test_holidays_method_no_parameter : Tests(1) {
    my $self = shift;

    lives_ok { $self->{dh}->holidays() }
        'Testing holidays with no parameter for: '. $self->{dh}->{'_inner_class'};

    return 1;
}

sub test_is_holiday_method_no_parameter : Tests(1) {
    my $self = shift;

    lives_ok { $self->{dh}->is_holiday() }
        'Testing is_holiday with no parameter for: '. $self->{dh}->{'_inner_class'};

    return 1;
}

1;
