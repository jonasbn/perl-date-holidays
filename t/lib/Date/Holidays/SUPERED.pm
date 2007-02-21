package Date::Holidays::SUPERED;

use base 'Date::Holidays::Super';

sub holidays {
    return { 1224 => 'christmas' };
}

sub is_holiday {
    my ($year, $month, $day) = @_;
    
    my $key;
    my $calendar = { 1224 => 'christmas' };

    if ($month && $day) {
        $key  = $month.$day;
    }

    if ($key && $calendar->{$key}) {
        return $calendar->{$key};
    }
}

1;