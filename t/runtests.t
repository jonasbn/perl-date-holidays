#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib", "$Bin/../t";

use Test::Class::Date::Holidays::Local;

Test::Class->runtests();
