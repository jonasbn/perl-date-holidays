package Date::Holidays::Local;

use strict;
use warnings;
use File::Slurp qw(slurp);
use JSON; #from_json
use Env qw($HOLIDAYS_FILE);

sub new {
    my $class = shift;

    my $self = bless {}, $class;

    return $self;
};

sub holidays {
    my ($self, %params) = @_;

    my $holiday_file = $self->_resolve_holiday_file();

    my $holidays = {};
    if (-r $holiday_file) {

        my $json = slurp($holiday_file);
        $holidays = from_json($json);
    }

    use Data::Dumper;
    print STDERR Dumper $holidays;

    if ($params{year}) {
        my $tmp_holidays;

        foreach my $key (%{$holidays}) {
            if ($key =~ m/(\d{4})\d{2}\d{2}/
                    and $1 != $params{year}) {
                next;

            } else {
                $tmp_holidays->{$key} = $holidays->{$key};
            }
        }
        $holidays = $tmp_holidays;
    }

    return $holidays;
}

sub is_holiday {
    my ($self, %params) = @_;

    my $holidays = $self->holidays(year => $params{year});

    my $key;
    if ($params{year}) {
        $key = $params{year}.$params{month}.$params{day};

        if ($holidays->{$key}) {
            return $holidays->{$key};
        }
    }

    $key = $params{month}.$params{day};

    if ($holidays->{$key}) {
        return $holidays->{$key};
    }

    return '';
}

sub _resolve_holiday_file {
    my $self = shift;

    my $filename = '';

    if (-e $HOLIDAYS_FILE and -f _) {
        $filename = $HOLIDAYS_FILE;
    }
}

1;
