#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Date::Holidays;

# Initialize a national holidays using the ISO 3361 country code
my $dh = Date::Holidays->new(
    nocheck     => 1,
    countrycode => 'USFederal'
);

print STDERR Dumper $dh;

my ($year, $month, $day) = (localtime)[ 5, 4, 3 ];
$year  += 1900;
$month += 1;

print "#########################\n";

print "\nWoohoo\n" if $dh->is_holiday( year => $year, month => $month, day => $day );

print "\nWoohoo\n" if $dh->is_holiday( year => 2018, month => 12, day => 25 );


exit 0;

