package Test::Class::Date::Nonpolymorphic;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;

my $month = 12;
my $day   = 24;
my $year  = 2007;

#run prior and once per suite
sub startup : Test(startup => 2) {
	diag "starting up...";
	use_ok('Date::Holidays');
    use_ok('Date::Holidays::NONPOLYMORPHIC');
}

sub test_nonpolymorphic : Test(12) {

	# bare

	ok(my $dh = Date::Holidays::NONPOLYMORPHIC->new());

	isa_ok($dh, 'Date::Holidays::NONPOLYMORPHIC', 'checking non-polymorphic class object');

	can_ok($dh, qw(new nonpolymorphic_holidays is_nonpolymorphic_holiday));

	ok($dh->nonpolymorphic_holidays($year));

	ok($dh->is_nonpolymorphic_holiday($year, $month, $day));

	# wrapper

	ok($dh = Date::Holidays->new(nocheck => 1, countrycode => 'nonpolymorphic'));

	isa_ok($dh, 'Date::Holidays', 'checking wrapper object');


	is($dh->is_holiday(year => $year, month => $month, day => $day), 'christmas');

	ok(my $href = $dh->holidays(year => $year));

	is(ref $href, 'HASH');

	#inner

	use Data::Dumper;
	print STDERR Dumper $dh;


	isa_ok($dh->{_inner_object}, 'Date::Holidays::Adapter', 'checking _inner_object');

	can_ok($dh->{_inner_object}, qw(new is_holiday holidays));
}

1;
