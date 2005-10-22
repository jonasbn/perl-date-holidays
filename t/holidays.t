# $Id: holidays.t 1598 2005-10-22 05:51:03Z jonasbn $

use strict;
use Test::More tests => 6;

my $debug = 0;
use_ok('Date::Holidays');

my $dh = Date::Holidays->new(
	countrycode => 'dk'
);

ok(ref $dh);

ok($dh->holidays(
	year => 2004
));

SKIP: {
	eval { require Date::Holidays::PT };	
    skip "Date::Holidays::PT not installed", 3 if $@;

	unless ($@) {
		ok($dh = Date::Holidays->new(
			countrycode => 'pt'
		));

		ok(my $data = $dh->holidays(
			year => 2005
		));    
	
		ok($dh->holidays(
			year => 2005
		));
	}
}
