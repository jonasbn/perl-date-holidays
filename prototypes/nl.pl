#!/usr/bin/env perl

use strict;
use warnings;
use Date::Holidays;
use Data::Dumper;

my $dh = Date::Holidays->new(
    countrycode => 'nl'
);

my $holidays = $dh->holidays();

print STDERR Dumper $holidays;
