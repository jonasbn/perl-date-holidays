package Test::Class::Date::Holidays::Produceral;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;

my $day   = 24;
my $month = 12;
my $year  = 2007;


#run prior and once per suite
sub startup : Test(startup => 2) {
	diag("starting up...");
	
	use_ok('Date::Holidays');
	use_ok('Date::Holidays::PRODUCERAL');
}

sub test_produceral_interface : Test(11) {

	# bare

	can_ok('Date::Holidays::PRODUCERAL', qw(holidays is_holiday));

	ok(Date::Holidays::PRODUCERAL::holidays($year), 'calling holidays directly');

	is(Date::Holidays::PRODUCERAL::is_holiday($year, $month, $day), 'christmas', 'calling is_holiday directly');

	# wrapper

	ok(my $dh = Date::Holidays->new(nocheck => 1, countrycode => 'produceral'), 'instantiating Date::Holidays');

	isa_ok($dh, 'Date::Holidays', 'checking wrapper object');

	is($dh->is_holiday(year => $year, month => $month, day => $day), 'christmas', 'calling is_holiday via wrapper');

	ok(my $holidays = $dh->holidays(), 'calling holidays via wrapper');

	is(keys %{$holidays}, 1, 'we have one and only one holiday');

	is($holidays->{$month.$day}, 'christmas', 'christmas is present');

	#inner

	can_ok($dh->{_inner_class}, qw(holidays is_holiday));
	isa_ok($dh->{_inner_object}, 'Date::Holidays::Adapter', 'we have no notion of inner object');
}

1;
