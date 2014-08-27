
use strict;
use Test::More tests => 6;

use lib qw(lib ../lib);
use Date::Holidays;

use lib qw(t/lib);

SKIP: {
    eval { require Date::Holidays::Abstract };
    skip "Date::Holidays::Abstract not installed", 6 if $@;

    use_ok('Date::Holidays::ABSTRACTED');

    ok(my $dh = Date::Holidays->new(nocheck => 1, countrycode => 'ABSTRACTED'));

    isa_ok($dh, 'Date::Holidays', 'Testing object');

    can_ok($dh, qw(new holidays is_holiday));

    ok($dh->holidays(), 'Testing holidays');

    ok($dh->is_holiday(year => 2007, month => 12, day => 24), 'Testing christmas');
};