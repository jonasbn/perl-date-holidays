#!/usr/bin/perl -w

use lib qw(blib/lib);
use Date::Holidays;

my $dh = Date::Holidays->new(
			countrycode => 'de'
		);

$dh->holidays(year => 2005);

use Data::Dumper;
use Date::Holidays::DE;
my $holidays = Date::Holidays::DE::holidays();

print STDERR Dumper $holidays;
