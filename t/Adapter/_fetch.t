# $Id$

use strict;
use Test::More tests => 6;

use_ok('Date::Holidays::Adapter');

SKIP: {
    eval { require Date::Holidays::DK };
    skip "Date::Holidays::DK not installed", 5 if $@;

    ok(my $adapter = Date::Holidays::Adapter->new(countrycode => 'DK'));

    isa_ok($adapter, 'Date::Holidays::Adapter');

    ok($adapter->_fetch({no_check => 1}));

    is($adapter->{_countrycode}, 'dk');

    is($adapter->{_adaptee}, 'Date::Holidays::DK');
}