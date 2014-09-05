package Test::Class::Date::Holidays::Abstracted;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;

#run prior and once per suite
sub startup : Test(startup => 1) {
	diag("starting up...");

	use_ok('Date::Holidays');
}

sub test_abstracted : Test(6) {
	SKIP: {
	    eval { require Date::Holidays::Abstract };
	    skip "Date::Holidays::Abstract not installed", 6 if $@;

	    use_ok('Date::Holidays::Abstracted');

	    ok(my $dh = Date::Holidays->new(nocheck => 1, countrycode => 'Abstracted'));

	    isa_ok($dh, 'Date::Holidays', 'Testing object');

	    can_ok($dh, qw(new holidays is_holiday));

	    ok($dh->holidays(), 'Testing holidays');

	    is($dh->is_holiday(year => 2007, month => 12, day => 24), 'christmas','Testing christmas');
	};
}

1;
