#!/usr/bin/env perl

use strict;
use warnings;

use Date::Holidays::GB;

my $sub = Date::Holidays::GB->can('is_holiday');

#print STDERR &{$sub}(year => 2004, month => 12, day => 25);

print STDERR &{$sub}(2014, 12, 25);
