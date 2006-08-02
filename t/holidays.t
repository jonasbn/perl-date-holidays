# $Id: holidays.t 1622 2006-08-02 19:51:45Z jonasbn $

use strict;
use Test::More tests => 11;

my $debug = 0;
use_ok('Date::Holidays');

my $dh = Date::Holidays->new(
	countrycode => 'dk'
);

ok(ref $dh);

ok($dh->holidays(
	year => 2004
));

SKIP: {
	eval { require Date::Holidays::PT };	
    skip "Date::Holidays::PT not installed", 2 if $@;

	unless ($@) {
		ok($dh = Date::Holidays->new(
			countrycode => 'pt'
		));

		ok($dh->holidays(
			year => 2005
		));    
	}
}

SKIP: {
	eval { require Date::Holidays::AU };	
    skip "Date::Holidays::NZ not installed", 3 if $@;

	unless ($@) {
		ok($dh = Date::Holidays->new(
			countrycode => 'au'
		));

		ok($dh->holidays(
			year  => 2006
		));    
	
		ok($dh->holidays(
			year  => 2006,
			state => 'VIC',
		));
	}
}

SKIP: {
	eval { require Date::Holidays::DE };	
    skip "Date::Holidays::DE not installed", 3 if $@;

	unless ($@) {
		ok($dh = Date::Holidays->new(
			countrycode => 'de'
		));

		ok($dh->holidays()); #This should be doable according to the synopsis 
		
		ok($dh->holidays(
			year => 2006
		));    
	}
}
