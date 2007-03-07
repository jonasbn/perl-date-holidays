# $Id$

use strict;
use Test::More tests => 20;
use DateTime;

#test 1
BEGIN {
	use lib qw(lib ../lib);
	use_ok( 'Date::Holidays' );
};

SKIP: {
	eval { require Date::Holidays::DK };
    skip "Date::Holidays::DK not installed", 19 if $@;

	ok(my $dh = Date::Holidays->new(countrycode => 'dk'));

	my $dt = DateTime->new(
		year  => 2004,
		month => 12,
		day   => 24,
	);
	
	#test 2
	ok($dh->is_holiday_dt($dt));
	
	$dt = DateTime->new(
		year  => 2004,
		month => 1,
		day   => 15,
	);
	
	ok(! $dh->is_holiday_dt($dt));
	
	my $hashref;
	ok($hashref = $dh->holidays_dt(year => 2004));
	
	is(keys %{$hashref}, 14);
	
	foreach my $dt (keys %{$hashref}) {
		is(ref $hashref->{$dt}, 'DateTime');
	}
}