package Date::Holidays::SUPERED;

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
    my ($class, $year, $month, $day) = @_;
    
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