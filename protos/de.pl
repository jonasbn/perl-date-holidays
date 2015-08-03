#!/usr/bin/perl -w

use lib qw(blib/lib);
use Date::Holidays;

my $dh = Date::Holidays->new(
			countrycode => 'de'
		);

$dh->holidays(year => 2005);
