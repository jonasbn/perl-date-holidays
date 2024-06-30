#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
use Date::Holidays;

my $holidays_hashref = Date::Holidays->is_holiday(
    year      => 2024,
    month     => 12,
    day       => 25,
    countries => ['CW'],
);

print STDERR Dumper($holidays_hashref);

exit 0;
