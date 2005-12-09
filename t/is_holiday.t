# $Id: is_holiday.t 1604 2005-12-09 22:00:06Z jonasbn $

use strict;
use Test::More tests => 11;
use Data::Dumper;

my $debug = 0;

#test 1
use_ok('Date::Holidays');

my $dh = Date::Holidays->new(
	countrycode => 'dk'
);

print STDERR Dumper $dh if $debug;

#test 2
ok(ref $dh);

#test 3
ok($dh->is_holiday(
	year  => 2004,
	month => 12,
	day   => 25
));

my $holidays_hashref;

#test 4
ok($holidays_hashref = $dh->is_holiday(
	year      => 2004,
	month     => 12,
	day       => 25,
	countries => ['se', 'dk'],
));

#test 5
is(keys %{$holidays_hashref}, 2);

#test 6-7
foreach my $country (keys %{$holidays_hashref}) {
	if ($holidays_hashref->{$country}) {
		print STDERR "$country = ".$holidays_hashref->{$country}."\n" if $debug;
	}
	ok($country);
}

#test 8
ok($holidays_hashref->{'dk'});

#test 9
SKIP: {
	eval { require Date::Holidays::SE };
    skip "Date::Holidays::SE installed", 1 unless ($@);
    
	is($holidays_hashref->{'se'}, undef);
}

print STDERR Dumper $holidays_hashref if $debug;

$dh = Date::Holidays->new();

#test 10
ok($holidays_hashref = $dh->is_holiday(
	year      => 2004,
	month     => 12,
	day       => 25,
));

if ($debug) {
	foreach my $country (keys %{$holidays_hashref}) {
		if ($holidays_hashref->{$country}) {
			print STDERR "$country = ".$holidays_hashref->{$country}."\n";
		}
	}
}
#test 11
print STDERR Dumper $holidays_hashref if $debug;

SKIP: {
	eval { require Date::Holidays::PT };
    skip "Date::Holidays::PT not installed", 1 if $@;
    
	ok($holidays_hashref->{'pt'});
}

