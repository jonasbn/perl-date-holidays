#!/usr/bin/env perl

use strict;
use warnings;

use Date::Holidays;

my $dh = Date::Holidays->new( countrycode => 'sk' );

print "Woohoo" if $dh->is_holiday( year => 2014, month => 1, day => 1 );


my $holidays_hashref = Date::Holidays->is_holiday(
    year  => 2014,
    month => 1,
    day   => 1,
    countries => [ 'sk', 'dk' ],
);

use Data::Dumper;
print STDERR Dumper $holidays_hashref;

use Date::Holidays::SK qw(
   is_sk_holiday
);

print "Woohoo" if is_sk_holiday( 2014, 1, 1 );
