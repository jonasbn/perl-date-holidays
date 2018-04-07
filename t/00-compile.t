#!/usr/bin/perl -w

# $Id: 00-load.t 5433 2013-01-15 11:12:40Z ejo $

#Courtesy of Ovid
#Ref: http://use.perl.org/~Ovid/journal/37797

use strict;
use warnings;

use FindBin qw($Bin);  ### ".../t"
use lib $Bin, "$Bin/../lib";

use File::Find;
use File::Spec;
use Test::More;

BEGIN {
    my $DIR = 'lib/';

    sub to_module($) {
        my $file = shift;
        $file =~ s{\.pm$}{};
        $file =~ s{\\}{/}g;    # to make win32 happy
        $file =~ s/^$DIR//;
        return join '::' => grep _ => File::Spec->splitdir($file);
    }

    my @modules;

    find({
            no_chdir => 1,
            wanted   => sub {
                push @modules => map { to_module $_ } $File::Find::name
                        if /\.pm$/;
            },
        }, $DIR
    );

    plan tests => scalar @modules;

    for my $module (@modules) {
        use_ok $module or BAIL_OUT("Could not use $module");
    }
}
