#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
use FindBin qw($Bin);
use lib "$Bin/../lib", "$Bin/../t", "$Bin/t", "$Bin";

use Date::Holidays;

my $dh = Date::Holidays->new(
    countrycode => 'nz'
);

my $holidays_hashref = $dh->holidays(year => 2018, region => 2);
print STDERR Dumper $holidays_hashref;

if ($dh->is_holiday(day => 1, month => 1, year => 2005)) {
    print "WOHOO\n!";
} else {
    print "ENOHOLIDAY\n";
}

use Date::Holidays::NZ;

if (my $holiday = is_nz_holiday(2018, 1, 1)) {
    print "WOHOO: $holiday\n!";
} else {
    print "ENOHOLIDAY\n";
}

