# $Id$

use strict;
use Test::More tests => 6;

BEGIN { use_ok('Date::Holidays::Adapter'); };

ok(my $adapter = Date::Holidays::Adapter->new(countrycode => 'DK'));

isa_ok($adapter, 'Date::Holidays::Adapter');

ok($adapter->_fetch({no_check => 1}));

is($adapter->{_countrycode}, 'dk');

is($adapter->{_adaptee}, 'Date::Holidays::DK');
