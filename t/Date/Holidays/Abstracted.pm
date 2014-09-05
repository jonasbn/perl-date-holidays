package Date::Holidays::Abstracted;

use strict;
use warnings;

use base 'Date::Holidays::Abstract';

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    return $self;
}

sub holidays {
    return { 1224 => 'christmas' };
}

sub is_holiday {
    my ($self, %params) = @_;

    my $calendar = $self->holidays(year => $params{year});
    
    my $key;
    if ($params{month} and $params{day}) {
        $key  = $params{month}.$params{day};
    }

    if ($key and $calendar->{$key}) {
        return $calendar->{$key};
    }
}

1;
