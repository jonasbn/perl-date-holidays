package Test::Class::Date::Time::Nonpolymorphic;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;

#run prior and once per suite
sub startup : Test(startup => 2) {
	diag "starting up...";
	use_ok('Date::Holidays');
    use_ok('Date::Holidays::Nonpolymorphic');
}

sub test_nonpolymorphic : Test(14) {
	# bare

	ok(my $dh = Date::Holidays::Nonpolymorphic->new());

	isa_ok($dh, 'Date::Holidays::Nonpolymorphic', 'checking non-polymorphic class object');

	can_ok($dh, qw(new));
	can_ok($dh, qw(nonpolymorphic_holidays));
	can_ok($dh, qw(is_nonpolymorphic_holiday));

	ok($dh->nonpolymorphic_holidays());

	ok($dh->is_nonpolymorphic_holiday(year => 2007, month => 12, day => 24));

	# wrapper

	ok($dh = Date::Holidays->new(nocheck => 1, countrycode => 'Nonpolymorphic'));

	isa_ok($dh, 'Date::Holidays', 'checking wrapper object');

	is($dh->is_holiday(year => 2007, month => 12, day => 24), 'christmas');

	ok(my $href = $dh->holidays(year => 2007));

	is(ref $href, 'HASH');

	#inner

	isa_ok($dh->{_inner_object}, 'Date::Holidays::Adapter::Nonpolymorphic', 'checking _inner_object');

	can_ok($dh->{_inner_object}, qw(new is_holiday holidays));
}

1;
