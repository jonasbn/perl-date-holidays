package Test::Class::Date::Holidays;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;

#run prior and once per suite
sub startup : Test(startup => 1) {

	# Testing compilation of component
    use_ok('Date::Holidays');
}

sub constructor : Test(5) {

	# Constructor requires country code so this test relies on
	# Date::Holidays::DK
    SKIP: {
    	eval { require Date::Holidays::DK };
    	skip "Date::Holidays::DK not installed", 5 if $@;

    	ok( my $dh = Date::Holidays->new( countrycode => 'DK', nocheck => 1 ) );

    	isa_ok( $dh, 'Date::Holidays', 'checking wrapper object' );

    	can_ok( $dh, qw(new), 'new' );

    	can_ok( $dh, qw(holidays), 'holidays' );

    	can_ok( $dh, qw(is_holiday), 'is_holiday' );
	}
}

sub _fetch : Test(2) {

	# Constructor requires country code so this test relies on
	# Date::Holidays::DK
	SKIP: {
	    eval { require Date::Holidays::DK };
	    skip "Date::Holidays::DK not installed", 2 if $@;

	    ok( my $dh = Date::Holidays->new( countrycode => 'DK' ) );

	    can_ok( $dh, '_fetch' );
	}
}

sub _load : Test(1) {

	#Testing load with something from own distribution
	ok(my $mod = Date::Holidays->_load('Date::Holidays::Adapter'));
}

1;
