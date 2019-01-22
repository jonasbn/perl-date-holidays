package Test::Class::Date::Holidays::CountryCode;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class);

#run prior and once per suite
sub startup : Test(startup => 1) {

    # Testing compilation of component
    use_ok('Date::Holidays');
}

sub test_constructor {
    my ($self, %params) = @_;

    my $countrycode = $params{countrycode};

    ok( my $dh = Date::Holidays->new( countrycode => $countrycode ),
        "Testing contructor with parameter country code: »$countrycode");

    $self->{dh} = $dh;
}

sub test_holidays_method {
    my ($self, %params) = @_;

    my $year = $params{year};

    ok( $self->{dh}->holidays( year => $year ),
        "Testing holidays with parameter year »$year« for: ". $self->{dh}->{'_inner_class'} );
}

sub test_is_holiday_method {
    my ($self, %params) = @_;

    my $year  = $params{year};
    my $month = $params{month};
    my $day   = $params{day};

    ok( $self->{dh}->is_holiday( year => $year, month => $month, day => $day ),
        "Testing holidays with parameters year »$year«, month »$month«, day »$day« for ". $self->{dh}->{'_inner_class'} );

}

sub test_is_holiday_method_with_countries {
    my ($self, %params) = @_;

    my $year        = $params{year};
    my $month       = $params{month};
    my $day         = $params{day};
    my $countries   = $params{countries};
    my $countrycode = $params{countrycode};

    ok(my $holidays = Date::Holidays->is_holiday(
       year      => $year,
       month     => $month,
       day       => $day,
       countries => $countries,
    ));

    ok( $holidays->{$countrycode},
        "Testing holidays with parameters year »$year«, month »$month«, day »$day« for ". $self->{dh}->{'_inner_class'} );
}

sub test_at : Test(6) {
    my $test = shift;

    SKIP: {
        eval { require Date::Holidays::AT };
        skip "Date::Holidays::AT not installed", 6 if $@;

        # Asserting that our adaptee can what we expect or not
        ok(! Date::Holidays::AT->can('is_holiday'));
        can_ok('Date::Holidays::AT', qw(holidays));

        $test->test_constructor(
            countrycode => 'at'
        );

        $test->test_holidays_method(
            year => 2007
        );

        $test->test_is_holiday_method(
            year  => 2007,
            month => 1,
            day   => 1
        );

        $test->test_is_holiday_method_with_countries(
            year        => 2007,
            month       => 1,
            day         => 1,
            countries   => [ 'at' ],
            countrycode => 'at'
        );
    };
}

1;
