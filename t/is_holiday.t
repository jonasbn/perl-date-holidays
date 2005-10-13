# $Id: is_holiday.t 1592 2005-10-13 06:36:33Z jonasbn $

use strict;
use Test::More tests => 12;
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
	countries => ['se', 'dk', 'no'],
));

#test 5
is(keys %{$holidays_hashref}, 3);

#test 6-8
foreach my $country (keys %{$holidays_hashref}) {
	if ($holidays_hashref->{$country}) {
		print STDERR "$country = ".$holidays_hashref->{$country}."\n" if $debug;
	}
	ok($country);
}

#test 9
ok($holidays_hashref->{'dk'});

#test 10
is($holidays_hashref->{'se'}, undef);

print STDERR Dumper $holidays_hashref if $debug;

$dh = Date::Holidays->new();

#test 11
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
#test 12
print STDERR Dumper $holidays_hashref if $debug;

ok($holidays_hashref->{'pt'});
