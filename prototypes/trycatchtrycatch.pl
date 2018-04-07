#!/usr/bin/env perl

use strict;
use warnings;

use TryCatch;

try {

    die "Die at first try\n";

} catch ($e1) {
    warn "Caught exception: $e1\n";
    try {
        die "Retry\n";

    } catch ($e1) {
        warn "Caught exception: $e1\n";
    };
};
