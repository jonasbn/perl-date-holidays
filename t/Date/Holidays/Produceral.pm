package Date::Holidays::Produceral;

use strict;
use warnings;

sub holidays {
    return { 1224 => 'christmas' };    
}

sub is_holiday {
    my %params = @_;

    my $key;
    if ($params{month} and $params{day}) {
        $key  = $params{month}.$params{day};
    }

    my $holidays = holidays();

    if ($key and $holidays->{$key}) {
        return $holidays->{$key};
    }
}

1;
