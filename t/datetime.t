# $Id$

use strict;
use Test::More tests => 18;
use Date::Holidays;
use DateTime;

my $dh = Date::Holidays->new(countrycode => 'dk');

my $dt = DateTime->new(
	year  => 2004,
	month => 12,
	day   => 25,
);

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
