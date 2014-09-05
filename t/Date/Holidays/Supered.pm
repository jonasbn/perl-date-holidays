package Date::Holidays::Supered;

use strict;
use warnings;

use base 'Date::Holidays::Super';

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
    
    my $key;
    my $calendar = $self->holidays();

    if ($params{month} and $params{day}) {
        $key  = $params{month}.$params{day};
    }

    if ($key && $calendar->{$key}) {
        return $calendar->{$key};
    }
}

1;