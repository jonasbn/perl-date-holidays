# $Id: is_holiday.t 1742 2007-02-22 19:47:55Z jonasbn $

use strict;
use Module::Load qw(load);
use Test::More tests => 17;

my $verbose = 0;
my ($dh, $holidays_hashref);

#test 1
use lib qw(lib ../lib);
use_ok('Date::Holidays');

SKIP: {
	eval { load Date::Holidays::DK };
    skip "Date::Holidays::DK not installed", 7 if ($@);

	eval { load Date::Holidays::SE };
    skip "Date::Holidays::SE not installed", 7 if ($@);

	$dh = Date::Holidays->new(
		countrycode => 'dk'
	);

	#test 2
	isa_ok($dh, 'Testing Date::Holidays object');

	#test 3
	ok($dh->is_holiday(
		year  => 2004,
		month => 12,
		day   => 25
	), 'Testing whether 1. christmas day is a holiday in DK');

	#test 4
	ok($holidays_hashref = $dh->is_holiday(
		year      => 2004,
		month     => 12,
		day       => 25,
		countries => ['se', 'dk'],
	), 'Testing whether 1. christmas day is a holiday in SE and DK');

	#test 5
	is(keys %{$holidays_hashref}, 2, 'Testing to see if we got two definitions');

	#test 6-7
	foreach my $country (keys %{$holidays_hashref}) {
		if ($holidays_hashref->{$country}) {
			print STDERR "$country = ".$holidays_hashref->{$country}."\n" if $verbose;
		}
		ok($country. 'Testing our specified countries');
	}

	#test 8    
	is($holidays_hashref->{'dk'}, undef, 'Testing whether DK is set');
}

#test 9
ok($holidays_hashref = Date::Holidays->is_holiday(
	year      => 2004,
	month     => 12,
	day       => 25,
), 'Testing is_holiday called without an object');

#foreach my $country (keys %{$holidays_hashref}) {
#    if ($holidays_hashref->{$country}) {
#        print STDERR "$country = ".$holidays_hashref->{$country}."\n";
#    }
#}

#test 10
SKIP: {
	eval { load Date::Holidays::PT };
    skip "Date::Holidays::PT not installed", 1 if $@;
    
	ok($holidays_hashref->{'pt'}, 'Checking for Portuguese first day of year');
}

#test 11
SKIP: {
	eval { load Date::Holidays::AU };
    skip "Date::Holidays::AU not installed", 1 if $@;
    
	ok(! $holidays_hashref->{'au'}, 'Checking for Australian first day of year');
}

#test 13
SKIP: {
	eval { load Date::Holidays::AT };
    skip "Date::Holidays::AT not installed", 1 if $@;
    
	ok(! $holidays_hashref->{'at'}, 'Checking for Austrian first day of year');
}

#test 14
SKIP: {
	eval { load Date::Holidays::ES };
    skip "Date::Holidays::ES not installed", 1 if $@;
    
	ok($holidays_hashref->{'es'}, 'Checking for Spanish christmas');
}

#test 15
SKIP: {
	eval { load Date::Holidays::NZ };
    skip "Date::Holidays::NZ not installed", 1 if $@;
    
	ok(! $holidays_hashref->{'nz'}, 'Checking for New Zealandian christmas');
}

#test 16
SKIP: {
	eval { load Date::Holidays::NO };
    skip "Date::Holidays::NO not installed", 1 if $@;
    
	ok($holidays_hashref->{'no'}, 'Checking for Norwegian christmas');
}

#test 17
SKIP: {
	eval { load Date::Holidays::FR };
    skip "Date::Holidays::FR not installed", 1 if $@;
    
	ok($holidays_hashref->{'fr'}, 'Checking for French christmas');
}

#test 18
SKIP: {
	eval { load Date::Holidays::CN };
    skip "Date::Holidays::CN not installed", 1 if $@;
    
	ok(! $holidays_hashref->{'cn'}, 'Checking for Chinese first day of year');
}
