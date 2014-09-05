package Test::Class::Date::Holidays;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;

#run prior and once per suite
sub startup : Test(startup => 1) {

    use_ok('Date::Holidays');

    return 1;
}

#run after and once per suite
sub shutdown : Test(shutdown) {
    # body...

    return 1;
}

sub constructor : Test(5) {
    my ($self) = @_;

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

#run prior and once per test method
sub setup : Test(setup) {
    # body...

    return 1;
}

#run after and once per test method
sub teardown : Test(teardown) {
    # body...

    return 1;
}

1;