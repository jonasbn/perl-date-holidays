package Date::Holidays::Adapter::CN;

use strict;
use warnings;

use base 'Date::Holidays::Adapter';

use vars qw($VERSION);

$VERSION = '0.20';

sub holidays {
    my ($self, %params) = @_;

    my $dh = $self->{_adaptee}->new();

    if ($dh) {
        return $dh->cn_holidays($params{'year'});
    } else {
        return;
    }
}

sub is_holiday {
    my ($self, %params) = @_;

    my $dh = $self->{_adaptee}->new();

    if ($dh) {
        return $dh->cn_holidays($params{'year'}, $params{'month'}, $params{'day'});
    } else {
        return;
    }
}

1;
