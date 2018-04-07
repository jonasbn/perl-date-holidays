#!/usr/bin/env perl

use strict;
use warnings;

use Try::Tiny;

try {

    die "Die at first try\n";

} catch {
    warn "Caught exception: $_\n";
    try {
        die "Retry\n";

    } catch {
        warn "Caught exception: $_\n";
    };
};
