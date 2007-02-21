
use strict;
use Test::More qw(no_plan);

use lib qw(lib ../lib);
use Date::Holidays;

BEGIN {
    use lib qw(t/lib);
    use_ok('Date::Holidays::NOPOLY');
};

# bare

ok(my $dhnopoly = Date::Holidays::NOPOLY->new());

isa_ok($dhnopoly, 'Date::Holidays::NOPOLY', 'checking NOPOLY class object');

can_ok($dhnopoly, qw(new));
can_ok($dhnopoly, qw(nopoly_holidays));
can_ok($dhnopoly, qw(is_nopoly_holiday));

ok($dhnopoly->nopoly_holidays());

ok($dhnopoly->is_nopoly_holiday(year => 2007, month => 12, day => 24));

# wrapper

ok(my $dh = Date::Holidays->new(nocheck => 1, countrycode => 'NOPOLY'));

isa_ok($dh, 'Date::Holidays', 'checking wrapper object');

is($dh->is_holiday(year => 2007, month => 12, day => 24), 'christmas');

ok(my $href = $dh->holidays(year => 2007));

is(ref $href, 'HASH');

#inner

isa_ok($dh->{_inner_object}, 'Date::Holidays::Adapter::NOPOLY', 'checking _inner_object');

can_ok($dh->{_inner_object}, qw(new));
