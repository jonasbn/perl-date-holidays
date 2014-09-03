package Test::Class::Date::Holidays::Local;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Env qw($HOLIDAYS_FILE);

#run prior and once per suite
sub startup2 : Test(startup => 1) {
    my $self = shift;

    diag("startup");

    use_ok('Date::Holidays');

    return 1;
}

sub testing : Test(1) {
    my ($self) = @_;
    # body...

    ok(1);

    return 1;
}

#run after and once per suite
sub shutdown : Test(shutdown) {
    my $self = shift;

    diag("shutdown");

    # body...

    return 1;
}

#run prior and once per test method
sub setup : Test(setup => 2) {
    my $self = shift;

    diag("setup");
    use_ok('Date::Holidays::Local');

    $HOLIDAYS_FILE = 't/local.json';

    my $dh = Date::Holidays->new(countrycode => 'local');

    isa_ok($dh, 'Date::Holidays');

    use Data::Dumper;
    print STDERR Dumper $dh;

    return 1;
}

#run after and once per test method
sub teardown : Test(teardown) {
    my $self = shift;

    diag("teardown");
    # body...

    return 1;
}

1;
