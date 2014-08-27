
use strict;

use Test::More tests => 3;

BEGIN { use_ok('Date::Holidays'); }

SKIP: {
    eval { require Date::Holidays::DK };
    skip "Date::Holidays::DK not installed", 2 if $@;

    ok( my $dh = Date::Holidays->new( countrycode => 'DK' ) );

    can_ok( $dh, '_fetch' );
}
