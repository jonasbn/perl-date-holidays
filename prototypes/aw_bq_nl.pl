#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Data::Dumper;
use Date::Holidays;

my $holidays_hashref = Date::Holidays->is_holiday(
    year      => 2022,
    month     => 12,
    day       => 25,
    countries => ['nl', 'bq', 'aw'],
    lang      => 'en',
);

print STDERR Dumper($holidays_hashref);

exit 0;
