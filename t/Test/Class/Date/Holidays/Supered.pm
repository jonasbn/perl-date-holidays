package Test::Class::Date::Holidays::Supered;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;

#run prior and once per suite
sub startup : Test(startup => 1) {
	diag("starting up...");

	use_ok('Date::Holidays');
}

sub test_supered : Test(7) {

	SKIP: {
	    eval { require Date::Holidays::Super };

	    skip "Date::Holidays::Super not installed", 7 if $@;

	    use_ok('Date::Holidays::Supered');

	    ok(my $dh = Date::Holidays->new(nocheck => 1, countrycode => 'Supered'), 'Testing adaptability via Date::Holidays');

	    isa_ok($dh, 'Date::Holidays');

	    can_ok($dh, qw(new holidays is_holiday));

	    ok(my $href = $dh->holidays(year => 2007), 'Testing holidays method');

	    is(ref $href, 'HASH', 'Testing type of result from holidays method');

	    ok($dh->is_holiday(year => 2007, month => 12, day => 24), 'Testing is_holiday method');
	};
}

1;