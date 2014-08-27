
use strict;
use Test::More tests => 6;

BEGIN {
    use lib qw(lib ../lib);
    use_ok('Date::Holidays');
}

SKIP: {
    eval { require Date::Holidays::DK };
    skip "Date::Holidays::DK not installed", 5 if $@;

    ok( my $dh = Date::Holidays->new( countrycode => 'DK', nocheck => 1 ) );

    isa_ok( $dh, 'Date::Holidays', 'checking wrapper object' );

    can_ok( $dh, qw(new), 'new' );

    can_ok( $dh, qw(holidays), 'holidays' );

    can_ok( $dh, qw(is_holiday), 'is_holiday' );
}
