package Date::Holidays::PRODUCERAL;

my $calendar = { 1224 => 'christmas' };

sub holidays {
    return $calendar;    
}

sub is_holiday {
    my ($year, $month, $day) = @_;
    
    my $key;
    if ($month && $day) {
        $key  = "$month$day";
    }

    if ($key && $calendar->{$key}) {
        return $calendar->{$key};
    }
}

1;

1;