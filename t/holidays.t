# $Id: holidays.t 1731 2007-02-21 09:54:04Z jonasbn $

use strict;
use Test::More tests => 11;

my $debug = 0;
my $dh;

BEGIN {
    use lib qw(lib ../lib);
    use_ok('Date::Holidays');
};

SKIP: {
	eval { require Date::Holidays::DK };	
    skip "Date::Holidays::DK not installed", 2 if $@;

    ok($dh = Date::Holidays->new(
    	countrycode => 'dk'
    ), 'Testing Date::Holidays::DK');

    ok($dh->holidays(
    	year => 2004
    ), 'Testing holidays for Date::Holidays::DK');
}

SKIP: {
	eval { require Date::Holidays::PT };	
    skip "Date::Holidays::PT not installed", 2 if $@;
	
    ok($dh = Date::Holidays->new(
        countrycode => 'pt'
    ), 'Testing Date::Holidays::PT');

    ok($dh->holidays(
        year => 2005
    ), 'Testing holidays for Date::Holidays::PT');
	
}

SKIP: {
	eval { require Date::Holidays::AU };	
    skip "Date::Holidays::AU not installed", 3 if $@;

    ok($dh = Date::Holidays->new(
        countrycode => 'au'
    ), 'Testing Date::Holidays::AU');

    ok($dh->holidays(
        year  => 2006
    ), 'Testing holidays for Date::Holidays::AU');    

    ok($dh->holidays(
        year  => 2006,
        state => 'VIC',
    ), 'Testing holidays for Date::Holidays::AU');
}

SKIP: {
	eval { require Date::Holidays::DE };	
    skip "Date::Holidays::DE not installed", 3 if $@;

    ok($dh = Date::Holidays->new(
        countrycode => 'de'
    ), 'Testing Date::Holidays::DE');

    ok($dh->holidays(), 'Testing holidays with no arguments for Date::Holidays::DE');
    
    ok($dh->holidays(
        year => 2006
    ), 'Testing holidays with argument for Date::Holidays::DE');
}
