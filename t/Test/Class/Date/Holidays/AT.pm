package Test::Class::Date::Holidays::AT;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class);

#run prior and once per suite
sub startup : Test(startup => 1) {

    # Testing compilation of component
    use_ok('Date::Holidays');

    return 1;
}

sub setup : Test(setup => 2) {
    my $self = shift;

SKIP: {
    eval { require Date::Holidays::AT };
    $self->SKIP_ALL("darwin only") if $@;
    #skip "Date::Holidays::AT not installed", 2 if $@;

    # Asserting that our adaptee can what we expect or not
    ok(! Date::Holidays::AT->can('is_holiday'));
    can_ok('Date::Holidays::AT', qw(holidays));

    $self->{countrycode} = 'at';
}}

sub test_constructor : Tests(1) {
    my $self = shift;

    my $countrycode = $self->{countrycode};

    ok( my $dh = Date::Holidays->new( countrycode => $countrycode ),
        "Testing contructor with parameter country code: »$countrycode«");

    $self->{dh} = $dh;
}

sub test_holidays_method : Tests(1) {
    my $self = shift;

    my $year = 2017;

    ok( $self->{dh}->holidays( year => $year ),
        "Testing holidays with parameter year »$year« for: ". $self->{dh}->{'_inner_class'} );
}

sub test_is_holiday_method : Tests(1) {
    my $self = shift;

    my $year  = 2017;
    my $month = 1;
    my $day   = 1;

    ok( $self->{dh}->is_holiday( year => $year, month => $month, day => $day ),
        "Testing holidays with parameters year »$year«, month »$month«, day »$day« for ". $self->{dh}->{'_inner_class'} );
}

# sub test_is_holiday_method_with_countries : Tests(2) {
#     my $self = shift;

#     my $year        = 2017;
#     my $month       = 1;
#     my $day         = 1;
#     my $countries   = ['at'];
#     my $countrycode = 'at';

#     ok(my $holidays = Date::Holidays->is_holiday(
#        year      => $year,
#        month     => $month,
#        day       => $day,
#        countries => $countries,
#     ));

#     ok( $holidays->{$countrycode},
#         "Testing holidays with parameters year »$year«, month »$month«, day »$day« for ". $self->{dh}->{'_inner_class'} );
# }

1;
