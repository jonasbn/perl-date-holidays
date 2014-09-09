package Test::Class::Date::Holidays::Local;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Env qw($HOLIDAYS_FILE);

#run prior and once per suite
sub startup : Test(startup => 1) {

    diag("starting up...");

    use_ok('Date::Holidays');
}

#run prior and once per test method
sub setup : Test(setup => 2) {
    my $self = shift;

    diag("setting up...");

    ok(my $dh = Date::Holidays->new(countrycode => 'local'));

    isa_ok($dh, 'Date::Holidays');

    #storing our object for additonal tests
    $self->{dh} = $dh;
}

sub declaring_my_birthday_a_national_holiday : Test(2) {
    my $self = shift;

    $HOLIDAYS_FILE = 't/declaring_my_birthday_a_national_holiday.json';

    ok(my $holidays = $self->{dh}->holidays);

    is($holidays->{'1501'}, q[jonasbn's birthday]);
}

sub cancelling_christmas : Test(3) {
    my $self = shift;

    $HOLIDAYS_FILE = 't/cancelling_christmas.json';

    ok(my $holiday = $self->{dh}->is_holiday(
        year      => 2014,
        month     => 12,
        day       => 24,
        countries => ['+local','dk'],
    ));

    is($holiday->{'dk'}, '');
    is($holiday->{'local'}, '');
}

sub cancelling_christmas_for_all : Test(6) {
    my $self = shift;

    $HOLIDAYS_FILE = 't/cancelling_christmas.json';

    ok(my $holiday = $self->{dh}->is_holiday(
        year      => 2014,
        month     => 12,
        day       => 24,
        countries => ['dk'],
    ));

    ok($holiday = $self->{dh}->is_holiday(
        year      => 2015,
        month     => 12,
        day       => 24,
        countries => ['no'],
    ));

    ok($holiday = $self->{dh}->is_holiday(
        year      => 2014,
        month     => 12,
        day       => 24,
        countries => ['+local','dk', 'no'],
    ));

    is($holiday->{'dk'}, 'Yes it is Christmas in Denmark');
    is($holiday->{'no'}, '', 'Yes it is Christmas in Norway');
    is($holiday->{'local'}, undef, 'We have not local definition');
}

sub cancelling_christmas_next_year : Test(8) {
    my $self = shift;

    $HOLIDAYS_FILE = 't/cancelling_christmas_next_year.json';

    ok(my $holiday = $self->{dh}->is_holiday(
        year      => 2015,
        month     => 12,
        day       => 24,
        countries => ['dk'],
    ), 'testing christmas for DK 2015');

    is($holiday->{'dk'}, 'Juleaftensdag', 'Yes it is Christmas in Denmark');

    ok($holiday = $self->{dh}->is_holiday(
        year      => 2015,
        month     => 12,
        day       => 24,
        countries => ['+local','dk'],
    ), 'testing local calendar nullifies Christmas');

    is($holiday->{'dk'}, '', 'No Christmas in Denmark');
    is($holiday->{'local'}, '', 'No Christmas in local calendar');

    ok($holiday = $self->{dh}->is_holiday(
        year      => 2014,
        month     => 12,
        day       => 24,
        countries => ['+local','dk'],
    ), 'testing local calendar does not nullify Christmas in DK for 2014');

    is($holiday->{'dk'}, 'Juleaftensdag', 'asserting christmas');
    is($holiday->{'local'}, undef, 'asserting local calendar');
}

1;
