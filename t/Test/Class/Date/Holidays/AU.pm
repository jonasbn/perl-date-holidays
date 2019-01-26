package Test::Class::Date::Holidays::AU;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class);

#run prior and once per suite
sub startup : Test(startup => 1) {

    # Testing compilation of component
    use_ok('Date::Holidays');
}

sub setup : Test(setup => 1) {
    my $self = shift;

SKIP: {
    eval { require Date::Holidays::AU };
    $self->SKIP_ALL('Date::Holidays::AU not installed') if $@;

    # Asserting that our adaptee can what we expect or not
    can_ok('Date::Holidays::AU', qw(holidays is_holiday));

    $self->{countrycode} = 'au';
}}

sub test_constructor : Tests(1) {
    my $self = shift;

    my $countrycode = $self->{countrycode};

    ok( my $dh = Date::Holidays->new( countrycode => $countrycode ),
        "Testing contructor with parameter country code: »$countrycode«");

    $self->{dh} = $dh;
}

sub test_is_holiday_method_with_countries : Tests(2) {
    my $self = shift;

    my $year        = 2017;
    my $month       = 1;
    my $day         = 1;
    my $countries   = ['au'];
    my $countrycode = 'au';

    my $holidays = Date::Holidays->is_holiday(
       year      => $year,
       month     => $month,
       day       => $day,
       countries => $countries,
    );

    ok($holidays->{$countrycode},
        "Testing holidays with parameters year »$year«, month »$month«, day »$day« for ". $self->{dh}->{'_inner_class'} );
}

1;
