# $Id: holidays.t 1591 2005-10-11 14:33:05Z jonasbn $

use strict;
use Test::More tests => 4;

my $debug = 0;

use_ok('Date::Holidays');

my $dh = Date::Holidays->new(
	countrycode => 'dk'
);

ok(ref $dh);

ok($dh->holidays(
	year => 2004
));

$dh = Date::Holidays->new(
	countrycode => 'pt'
);

my $data = $dh->holidays(
	year => 2005
);

ok($dh->holidays(
	year => 2005
));