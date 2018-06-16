#!/usr/bin/env perl

use strict;
use warnings;

use Date::Holidays;

my $dh = Date::Holidays->new( countrycode => 'CA_ES', nocheck => 1 );

use Data::Dumper;
print STDERR Dumper $dh;

if ($dh->is_holiday(
    year   => 2017,
    month  => 6,
    day    => 24,
)) {
    print STDERR "Is catalan holiday\n";
} else {
    print STDERR "Is NOT a catalan holiday\n";
}

exit 0;
