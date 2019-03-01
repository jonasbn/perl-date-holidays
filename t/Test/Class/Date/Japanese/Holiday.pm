package Test::Class::Date::Japanese::Holiday;

use strict;
use warnings;
use Test::More;

use base qw(Test::Class::Date::Holidays::Base);

our $VERSION = '1.18';

sub setup : Test(setup => 2) {
	my $self = shift;

	# Asserting that our adaptee CNn what we expect or not
	can_ok('Date::Japanese::Holiday', qw(is_holiday is_japanese_holiday));

	$self->{countrycode} = 'JP';

	my $countrycode = $self->{countrycode};

	ok( my $dh = Date::Holidays->new( countrycode => $countrycode ),"Testing contructor with parameter country code: »$countrycode«" );

	$self->{dh} = $dh;

	return 1;
}

sub test_holidays_method : Tests(0) {
	my $self = shift;

	diag('holidays method is not supported by Date::Japanese::Holiday');

	return 1;
}

1;
