# $Id$

use strict;
use Test::More tests => 3;

BEGIN { use_ok('Date::Holidays::Adapter'); };

SKIP: {
	eval { require Date::Holidays::DK };	
    skip "Date::Holidays::DK not installed", 2 if $@;
    
    ok(my $adapter = Date::Holidays::Adapter->new(countrycode => 'DK'));

    isa_ok($adapter, 'Date::Holidays::Adapter');
}