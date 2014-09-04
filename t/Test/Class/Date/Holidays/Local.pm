package Test::Class::Date::Holidays::Local;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Env qw($HOLIDAYS_FILE);

#run prior and once per suite
sub startup : Test(startup => 1) {
    my $self = shift;

    diag("starting up...");

    use_ok('Date::Holidays');

    return 1;
}

sub declaring_my_birthday_a_national_holiday : Test(2) {
    my ($self) = @_;

    $HOLIDAYS_FILE = 't/declaring_my_birthday_a_national_holiday.json';

    ok(my $holidays = $self->{dh}->holidays);

    is($holidays->{'1501'}, q[jonasbn's birthday]);

    return 1;
}

sub cancelling_christmas : Test(1) {
    my ($self) = @_;

    $HOLIDAYS_FILE = 't/cancelling_christmas.json';

    ok(my $holiday = $self->{dh}->is_holiday(
        year      => 2014,
        month     => 12,
        day       => 24,
        countries => ['+local','DK'],
    ));

    use Data::Dumper;
    print STDERR Dumper $holiday;

    return 1;
}

#run after and once per suite
sub shutdown : Test(shutdown) {
    my $self = shift;

    diag("shutting down...");

    return 1;
}

#run prior and once per test method
sub setup : Test(setup => 2) {
    my $self = shift;

    diag("setting up...");

    ok(my $dh = Date::Holidays->new(countrycode => 'local'));

    isa_ok($dh, 'Date::Holidays');

    #storing our object for additonal tests
    $self->{dh} = $dh;

    return 1;
}

#run after and once per test method
sub teardown : Test(teardown) {
    my $self = shift;

    diag("tearing down...");


    return 1;
}

1;
