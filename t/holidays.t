# $Id: holidays.t 1333 2004-05-23 10:15:43Z jonasbn $

use strict;
use Test::More tests => 3;

my $debug = 0;

use_ok('Date::Holidays');

my $dh = Date::Holidays->new(
	countrycode => 'dk'
);

use Data::Dumper;
print STDERR Dumper $dh if $debug;

ok(ref $dh);

ok($dh->holidays(
	year => 2004
));
