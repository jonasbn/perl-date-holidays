package Test::Class::Date::Holidays::Abstracted;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;

my $year = 2007;
my $month = 12;
my $day = 24;

#run prior and once per suite
sub startup : Test(startup => 2) {
	diag("starting up...");

	use_ok('Date::Holidays');
	use_ok('Date::Holidays::ABSTRACTED');
}

sub test_abstracted : Test(9) {
	SKIP: {
	    eval { require Date::Holidays::Abstract };
	    skip "Date::Holidays::Abstract not installed", 6 if $@;

	    use_ok('Date::Holidays::Abstracted');

	    my $abstracted = Date::Holidays::ABSTRACTED->new();

	    ok($abstracted->holidays($year), 'Testing holidays');

	    is($abstracted->is_holiday($year, $month, $day), 'christmas','Testing christmas');

		ok(my $dh = Date::Holidays->new(nocheck => 1, countrycode => 'Abstracted'));
	    
	    ok($dh->holidays(year => $year), 'Testing holidays');

	    isa_ok($dh, 'Date::Holidays', 'Testing object');

	    can_ok($dh, qw(new holidays is_holiday));

	    ok($dh->holidays(year => $year), 'Testing holidays');

	    is($dh->is_holiday(year => $year, month => $month, day => $day), 'christmas','Testing christmas');
	};
}

1;
