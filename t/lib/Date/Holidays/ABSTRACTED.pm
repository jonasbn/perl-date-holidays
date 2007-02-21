package Date::Holidays::ABSTRACTED;

use base 'Date::Holidays::Abstract';

sub holidays {
    return { 1224 => 'christmas' };    
}

sub is_holiday {
    my ($year, $month, $day) = @_;
    
    my $calendar = { 1224 => 'christmas' };
    my $key;
    if ($month && $day) {
        $key  = $month.$day;
    }

    if ($key && $calendar->{$key}) {
        return $calendar->{$key};
    }
}

1;
