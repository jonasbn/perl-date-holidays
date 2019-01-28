package Test::Class::Date::Holidays::Base;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More; # done_testing
use Test::Fatal qw(dies_ok);
use Env qw($TEST_VERBOSE);

BEGIN {
    # Abstract class
    Test::Class::Date::Holidays::Base->SKIP_CLASS( 1 );
};

#run prior and once per suite
sub startup : Test(startup => 1) {
    my $self = shift;

    # Testing compilation of component
    use_ok('Date::Holidays');

    my ($year) = (localtime(time))[5] + 1900;
    $self->{year} = $year;

    return 1;
}

sub test_constructor : Tests(1) {
    my $self = shift;

    my $countrycode = $self->{countrycode};

    ok( my $dh = Date::Holidays->new( countrycode => $countrycode ),
        "Testing contructor with parameter country code: »$countrycode«");

    $self->{dh} = $dh;
}

sub test_holidays_method : Tests(1) {
    my $self = shift;

    my $year = $self->{year};

    ok( $self->{dh}->holidays( year => $year ),
        "Testing holidays with parameter year »$year« for: ". $self->{dh}->{'_inner_class'} );
}

sub test_is_holiday_method : Tests(1) {
    my $self = shift;

    my $year  = $self->{year};
    my $month = 1;
    my $day   = 1;

    ok( $self->{dh}->is_holiday( year => $year, month => $month, day => $day ),
        "Testing holidays with parameters year »$year«, month »$month«, day »$day« for ". $self->{dh}->{'_inner_class'} );
}

1;
