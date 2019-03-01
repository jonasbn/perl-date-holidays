package Test::Class::Date::Holidays::Base;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Test::Fatal qw(dies_ok);
use Env qw($TEST_VERBOSE);

our $VERSION = '1.18';

BEGIN {
    # Abstract class
    Test::Class::Date::Holidays::Base->SKIP_CLASS( 1 );
};

#run prior and once per suite
sub startup : Test(startup => 1) {
    my $self = shift;

    if ($TEST_VERBOSE) {
        diag('Running startup');
    }

    # Testing compilation of component
    use_ok('Date::Holidays');

    $self->{year} = (localtime(time))[5] + 1900;

    return 1;
}

sub test_constructor : Tests(1) {
    my $self = shift;

    my $countrycode = $self->{countrycode};

    ok( my $dh = Date::Holidays->new( countrycode => $countrycode ),
        "Testing contructor with parameter country code: »$countrycode«");

    $self->{dh} = $dh;

    return 1;
}

sub test_holidays_method : Tests(1) {
    my $self = shift;

    my $year = $self->{year};

    ok( $self->{dh}->holidays( year => $year ),
        "Testing holidays with parameter year »$year« for: ". $self->{dh}->{'_inner_class'} );

    return 1;
}

sub test_holidays_method_no_parameter : Tests(1) {
    my $self = shift;

    dies_ok { $self->{dh}->holidays() }
        'Testing holidays with no parameter for: '. $self->{dh}->{'_inner_class'};

    return 1;
}

sub test_is_holiday_method : Tests(1) {
    my $self = shift;

    my $year  = $self->{year};
    my $month = 1;
    my $day   = 1;

    ok( $self->{dh}->is_holiday( year => $year, month => $month, day => $day ),
        "Testing holidays with parameters year »$year«, month »$month«, day »$day« for ". $self->{dh}->{'_inner_class'} );

    return 1;
}

sub test_is_holiday_method_no_parameter : Tests(1) {
    my $self = shift;

    dies_ok { $self->{dh}->is_holiday() }
        'Testing holidays with no parameters for '. $self->{dh}->{'_inner_class'};

    return 1;
}

1;
