# $Id$

use strict;
use Date::Holidays;
use Test::More tests => 18;

my $verbose = 1;
my $t = 1;
my @countrycodes = qw(dk uk fr pt de jp);

foreach my $cc (@countrycodes) {

	print STDERR "\n[$t]: Testing country code: $cc\n" if $verbose;
	my $dh = Date::Holidays->new(
		countrycode => $cc,
	);
	ok(ref $dh); #tests 1, 4, 7, 10, 13, 16
	$t++;
	
	#test 2, 5, 8, 11, 14, 17
	print STDERR "\n[$t]: Testing holidays for: $cc\n" if $verbose;
	ok($dh->holidays(
		year => 2004
	));
	$t++;

	#test 3, 6, 9, 12, 15, 18
	print STDERR "\n[$t]: Testing is_holiday for: $cc\n" if $verbose;
	ok($dh->is_holiday(
		year  => 2004,
		month => 1,
		day   => 1
	));
	$t++;
}
