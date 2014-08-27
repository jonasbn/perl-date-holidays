
use strict;

use Test::More tests => 2;

BEGIN { use_ok('Date::Holidays'); };

ok(my $mod = Date::Holidays->_load('Date::Holidays::Adapter'));
