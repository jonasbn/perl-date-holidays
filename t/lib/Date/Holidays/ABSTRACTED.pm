package Date::Holidays::ABSTRACTED;

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
    my ($class, $year, $month, $day) = @_;

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
