#pod test courtesy of petdance
#http://use.perl.org/comments.pl?sid=18853&cid=28930

# $Id: 00.load.t 1734 2007-02-21 20:21:54Z jonasbn $

use Test::More tests => 10;

BEGIN { use_ok( 'Date::Holidays' ); }
BEGIN { use_ok( 'Date::Holidays::Adapter' ); }
BEGIN { use_ok( 'Date::Holidays::Adapter::AU' ); }
BEGIN { use_ok( 'Date::Holidays::Adapter::DE' ); }
BEGIN { use_ok( 'Date::Holidays::Adapter::DK' ); }
BEGIN { use_ok( 'Date::Holidays::Adapter::FR' ); }
BEGIN { use_ok( 'Date::Holidays::Adapter::GB' ); }
BEGIN { use_ok( 'Date::Holidays::Adapter::JP' ); }
BEGIN { use_ok( 'Date::Holidays::Adapter::NO' ); }
BEGIN { use_ok( 'Date::Holidays::Adapter::PT' ); }
