package Test::Class::Date::Holidays::Polymorphic;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;

#run prior and once per suite
sub startup : Test(startup => 2) {
    
    use_ok('Date::Holidays');
    use_ok('Date::Holidays::Polymorphic');

    return 1;
}

sub test_polymorhic : Test(15) {
    my ($self) = @_;

	# bare

	ok(my $dh = Date::Holidays::Polymorphic->new());

	isa_ok($dh, 'Date::Holidays::Polymorphic', 'checking OOP class object');

	can_ok($dh, qw(new));
	can_ok($dh, qw(holidays));
	can_ok($dh, qw(is_holiday));

	ok($dh->holidays());

	is($dh->is_holiday(year => 2007, month => 12, day => 24), 'christmas');

	# wrapper

	ok($dh = Date::Holidays->new(nocheck => 1, countrycode => 'Polymorphic'));

	isa_ok($dh, 'Date::Holidays', 'checking wrapper object');

	is($dh->is_holiday(year => 2007, month => 12, day => 24), 'christmas');

	ok($dh->holidays());

	#inner

	isa_ok($dh->{_inner_object}, 'Date::Holidays::Polymorphic', 'checking _inner_object');

	can_ok($dh->{_inner_object}, qw(new));
	can_ok($dh->{_inner_object}, qw(holidays));
	can_ok($dh->{_inner_object}, qw(is_holiday));
}

1;
