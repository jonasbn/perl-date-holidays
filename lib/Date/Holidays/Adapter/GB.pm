package Date::Holidays::Adapter::GB;

use strict;
use warnings;
use vars qw($VERSION);
use Error qw(:try);

use base 'Date::Holidays::Adapter';

$VERSION = '0.21';

sub holidays {
    my ($self, %params) = @_;

    my $sub = $self->{_adaptee}->can('holidays');

    if ($sub) {
        return &{$sub}(year => $params{'year'}, regions => $params{'regions'});
    } else {
        return;
    }
}

sub is_holiday {
    my ($self, %params) = @_;

    my $sub = $self->{_adaptee}->can('is_holiday');

    if ($sub) {
        return &{$sub}(year => $params{'year'}, month => $params{'month'}, day => $params{'day'}, regions => $params{'regions'});
    } else {
        return;
    }
}

1;