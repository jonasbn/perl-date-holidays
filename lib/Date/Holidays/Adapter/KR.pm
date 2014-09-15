package Date::Holidays::Adapter::KR;

use strict;
use warnings;
use vars qw($VERSION);
use Carp;

use base 'Date::Holidays::Adapter';

$VERSION = '1.00';

sub holidays {
    croak "holidays is unimplemented for ".__PACKAGE__;
}

sub is_holiday {
    my ($self, %params) = @_;

    my $sub = $self->{_adaptee}->can('is_fr_holiday');

    if ($sub) {
        return &{$sub}($params{'year'}, $params{'month'}, $params{'day'});
    } else {
        return;
    }
}

1;