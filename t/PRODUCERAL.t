
use strict;
use Test::More qw(no_plan);

use lib qw(lib ../lib);
use Date::Holidays;

BEGIN {
    use lib qw(t/lib);
    use_ok('Date::Holidays::PRODUCERAL');
};

# bare

can_ok('Date::Holidays::PRODUCERAL', qw(holidays));
can_ok('Date::Holidays::PRODUCERAL', qw(is_holiday));

ok(Date::Holidays::PRODUCERAL::holidays(year => 2007));

is(Date::Holidays::PRODUCERAL::is_holiday(2007, 12, 24), 'christmas');

# wrapper

ok(my $dh = Date::Holidays->new(nocheck => 1, countrycode => 'PRODUCERAL'));

isa_ok($dh, 'Date::Holidays', 'checking wrapper object');

is($dh->is_holiday(year => 2007, month => 12, day => 24), 'christmas');

ok($dh->holidays());

#inner

can_ok($dh->{_inner_class}, qw(holidays));
can_ok($dh->{_inner_class}, qw(is_holiday));
