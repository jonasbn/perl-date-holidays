package Date::Holidays::Adapter::DE;

use strict;
use warnings;
use Carp;

use base 'Date::Holidays::Adapter';

use vars qw($VERSION);

$VERSION = '1.14';

sub holidays {
    my ($self, %params) = @_;

    if ( $params{'year'} ) {
        return Date::Holidays::DE::holidays( YEAR => $params{'year'} );
    }
    else {
        return Date::Holidays::DE::holidays();
    }
}

sub is_holiday {
    my ($self, %params) = @_;

    my $holidays = Date::Holidays::DE::holidays(
        YEAR   => $params{'year'},
        FORMAT => "%#:%m%d"
    );

    my $holidays_hashref = $self->_transform_arrayref_to_hashref($holidays);

    my $holiday_date = sprintf('%02s%02s', $params{month}, $params{day});

    my $holiday = $holidays_hashref->{$holiday_date};

    if ($holiday) {
        return $holiday;
    } else {
        return '';
    }
}

sub _transform_arrayref_to_hashref {
    my ($self, $arrayref_of_holidays) = @_;

    my $hashref_of_holidays;

    foreach my $entry (@{$arrayref_of_holidays}) {
        my ($name, $key) = split /:/, $entry;
        $hashref_of_holidays->{$key} = $name;
    }

    return $hashref_of_holidays;
}

1;

__END__

=pod

=head1 NAME

Date::Holidays::Adapter::DE - an adapter class for Date::Holidays::DE

=head1 VERSION

This POD describes version 1.14 of Date::Holidays::Adapter::DE

=head1 DESCRIPTION

The is the adapter class for L<Date::Holidays::DE>.

=head1 SUBROUTINES/METHODS

=head2 new

The constructor, takes a single named argument, B<countrycode>

The constructor is inherited from L<Date::Holidays::Adapter>

=head2 is_holiday

Not implemented in L<Date::Holidays::Holiday>, calls to this throw the
L<Date::Holidays::Exception::UnsupportedMethod>

=head2 holidays

The B<holidays> method, takes a single named argument, B<year>

returns a reference to a hash holding the calendar of the country referenced by
B<countrycode> in the call to the constructor B<new>.

The calendar will spand for a year and the keys consist of B<month> and B<day>
concatenated.

=head1 DIAGNOSTICS

Please refer to DIAGNOSTICS in L<Date::Holidays>

=head1 DEPENDENCIES

=over

=item * L<Date::Japanese::Holiday>

=item * L<Date::Holidays::Adapter>

=back

=head1 INCOMPATIBILITIES

Please refer to INCOMPATIBILITIES in L<Date::Holidays>

=head1 BUGS AND LIMITATIONS

B<is_holiday> or similar method is not implemented in L<Date::Holidays::DE> as
of version 0.06.

The adapter does currently not support the complex API of
L<Date::Holidays::DE> B<holidays>.

Please refer to BUGS AND LIMITATIONS in L<Date::Holidays>

=head1 BUG REPORTING

Please refer to BUG REPORTING in L<Date::Holidays>

=head1 AUTHOR

Jonas B. Nielsen, (jonasbn) - C<< <jonasbn@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

L<Date::Holidays> and related modules are (C) by Jonas B. Nielsen, (jonasbn)
2004-2018

Date-Holidays and related modules are released under the Artistic License 2.0

=cut
