# pod.t file providing pod coverage test for Date-Holidays

# $Id: pod-coverage.t 1326 2004-05-22 17:33:00Z jonasbn $

#pod test courtesy of petdance
#http://use.perl.org/~petdance/journal/17412

use Test::More;
eval "use Test::Pod::Coverage 0.08";
plan skip_all => "Test::Pod::Coverage 0.08 required for testing POD coverage" if $@;
all_pod_coverage_ok();
