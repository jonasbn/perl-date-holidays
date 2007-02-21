
# $Id$

use strict;
use Test::More qw(no_plan);

use lib qw(lib);
use Date::Holidays;

BEGIN {
    use lib qw(t/lib);
    use_ok('Date::Holidays::OOP');
};

# bare

ok(my $dhoop = Date::Holidays::OOP->new());

isa_ok($dhoop, 'Date::Holidays::OOP', 'checking OOP class object');

can_ok($dhoop, qw(new));
can_ok($dhoop, qw(holidays));
can_ok($dhoop, qw(is_holiday));

ok($dhoop->holidays());

is($dhoop->is_holiday(year => 2007, month => 12, day => 24), 'christmas');

# wrapper

ok(my $dh = Date::Holidays->new(nocheck => 1, countrycode => 'OOP'));

isa_ok($dh, 'Date::Holidays', 'checking wrapper object');

is($dh->is_holiday(year => 2007, month => 12, day => 24), 'christmas');

ok($dh->holidays());

#inner

isa_ok($dh->{_inner_object}, 'Date::Holidays::Adapter::OOP', 'checking _inner_object');

can_ok($dh->{_inner_object}, qw(new));
can_ok($dh->{_inner_object}, qw(holidays));
can_ok($dh->{_inner_object}, qw(is_holiday));
