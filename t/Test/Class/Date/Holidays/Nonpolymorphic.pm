package Test::Class::Date::Holidays::Nonpolymorphic;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;

our $VERSION = '1.31';

my $month = 12;
my $day   = 24;
my $year  = 2007;

#run prior and once per suite
sub startup : Test(startup => 2) {
    use_ok('Date::Holidays');
    use_ok('Date::Holidays::Nonpolymorphic');
}

sub test_nonpolymorphic_interface : Test(13) {

    # bare

    ok(my $nonpolymorphic = Date::Holidays::Nonpolymorphic->new());
    isa_ok($nonpolymorphic, 'Date::Holidays::Nonpolymorphic', 'checking non-polymorphic class object');
    can_ok($nonpolymorphic, qw(new nonpolymorphic_holidays is_nonpolymorphic_holiday));

    ok($nonpolymorphic->nonpolymorphic_holidays($year));
    ok($nonpolymorphic->is_nonpolymorphic_holiday($year, $month, $day));

    # wrapper

    ok(my $dh = Date::Holidays->new(nocheck => 1, countrycode => 'Nonpolymorphic'));
    isa_ok($dh, 'Date::Holidays', 'checking wrapper object');
    can_ok($dh, qw(new holidays is_holiday));

    is($dh->is_holiday(year => $year, month => $month, day => $day), 'christmas');
    ok(my $href = $dh->holidays(year => $year));
    is(ref $href, 'HASH');

    #inner

    isa_ok($dh->{_inner_object}, 'Date::Holidays::Adapter', 'checking _inner_object');
    can_ok($dh->{_inner_object}, qw(new is_holiday holidays));
}

1;
