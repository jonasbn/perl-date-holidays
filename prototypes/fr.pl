#!/usr/bin/env perl

use strict;
use warnings;

use Date::Holidays::FR;
use Data::Dumper;

my $ref = fr_holidays;

print STDERR Dumper $ref;

$ref = holidays;

print STDERR Dumper $ref;

is_fr_holiday();

is_holiday();

exit 0;
