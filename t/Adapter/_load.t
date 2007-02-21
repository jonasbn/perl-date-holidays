# $Id$

use strict;
use Test::More tests => 4;

BEGIN { use_ok('Date::Holidays::Adapter'); };

ok(my $adapter = Date::Holidays::Adapter->new(countrycode => 'DK'));

isa_ok($adapter, 'Date::Holidays::Adapter');

ok($adapter->_load('Date::Holidays::Adapter::DK'));
