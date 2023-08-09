#!/usr/bin/env perl

use warnings;
use strict;

use FindBin;
use lib "$FindBin::Bin/../lib;$FindBin::Bin/lib";

use Date::Holidays;
use Data::Dumper;

my $dh = Date::Holidays->new( countrycode => 'dk' );
my $holidays = $dh->holidays( year => 2023 );

print Dumper $holidays;

exit 0;
