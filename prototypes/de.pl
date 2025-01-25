#!/usr/bin/perl -w

use lib qw(blib/lib);
use Date::Holidays;
use Data::Dumper;

my $dh = Date::Holidays->new(
    countrycode => 'de'
);

my $holidays = $dh->holidays( year => 2018, state => ['bb', 'sl']);

print STDERR Dumper $holidays;

$holidays = $dh->holidays( year => 2018,);

print STDERR Dumper $holidays;

$holidays = $dh->holidays( state => ['bb'] );

print STDERR Dumper $holidays;
