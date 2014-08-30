package Date::Holidays::Adapter::CN;

use strict;
use warnings;

use base 'Date::Holidays::Adapter';

use vars qw($VERSION);

$VERSION = '0.20';

sub holidays {
    my ($self, %params) = @_;

    my $sub = $self->{_adaptee}->can('cn_holidays');

    if ($sub) {
        return &{$sub}($params{'year'});
    } else {
        return;
    }
}

sub is_holiday {
    my ($self, %params) = @_;

    my $sub = $self->{_adaptee}->can('is_cn_holiday');

    if ($sub) {
        return &{$sub}($params{'year'}, $params{'month'}, $params{'day'});
    } else {
        return;
    }
}

1;
