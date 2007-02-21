
use strict;
use Test::More tests => 7;

use lib qw(lib);
use Date::Holidays;

use lib qw(t/lib);

SKIP: {
    eval { require Date::Holidays::Super };

    skip "Date::Holidays::Super not installed", 7 if $@;

    use_ok('Date::Holidays::SUPERED');

    ok(my $dh = Date::Holidays->new(nocheck => 1, countrycode => 'SUPERED'), 'Testing adaptability via Date::Holidays');

    isa_ok($dh, 'Date::Holidays');

    can_ok($dh, qw(new holidays is_holiday));

    ok(my $href = $dh->holidays(year => 2007), 'Testing holidays method');
    
    is(ref $href, 'HASH', 'Testing type of result from holidays method');

    ok($dh->is_holiday(year => 2007, month => 12, day => 24), 'Testing is_holiday method');
};
