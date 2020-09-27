#!/usr/bin/env perl

use strict;
use warnings;
use Date::Holidays;
use Data::Dumper;

my $dh = Date::Holidays->new(
    countrycode => 'aw'
);

if ($dh->is_holiday(
    year  => 2020,
    month => 3,
    day   => 18)
) { print "It is Betico day!"; }

my $holidays = $dh->holidays( year  => 2020 );

print STDERR Dumper $holidays;
