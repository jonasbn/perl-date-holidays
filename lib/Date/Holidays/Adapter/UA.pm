package Date::Holidays::Adapter::UA;

use strict;
use warnings;
use vars qw($VERSION);
use Carp;

use base 'Date::Holidays::Adapter';

$VERSION = '1.31';

sub holidays {
    my ($self, %params) = @_;

    my $sub = $self->{_adaptee}->can('holidays');

    if ($sub) {
        return &{$sub}($params{'year'});
    } else {
        return {};
    }
}

sub is_holiday {
    my ($self, %params) = @_;

    my $sub = $self->{_adaptee}->can('is_holiday');

    if ($sub) {
        return &{$sub}($params{'year'}, $params{'month'}, $params{'day'});
    } else {
        return;
    }
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Date::Holidays::Adapter::UA - an adapter class for Date::Holidays::UA

=head1 VERSION

This POD describes version 1.31 of Date::Holidays::Adapter::UA

=head1 DESCRIPTION

The is the adapter class for L<Date::Holidays::UA>.

=head1 SUBROUTINES/METHODS

=head2 new

The constructor, takes a single named argument, B<countrycode>

=head2 is_holiday

The B<holidays> method, takes 3 named arguments, B<year>, B<month> and B<day>

Returns an indication of whether the day is a holiday in the calendar of the
country referenced by B<countrycode> in the call to the constructor B<new>.

=head2 holidays

The B<holidays> method, takes a single named argument, B<year>

Returns a reference to a hash holding the calendar of the country referenced by
B<countrycode> in the call to the constructor B<new>.

The calendar will spand for a year and the keys consist of B<month> and B<day>
concatenated.

=head1 DIAGNOSTICS

Please refer to DIAGNOSTICS in L<Date::Holidays>

=head1 DEPENDENCIES

=over

=item * L<Date::Holidays::UA>

=item * L<Date::Holidays::Adapter>

=back

=head1 INCOMPATIBILITIES

Please refer to INCOMPATIBILITIES in L<Date::Holidays>

=head1 BUGS AND LIMITATIONS

The adapter does not implement the B<is_holiday> or B<holidays> methods.

=head1 BUG REPORTING

Please refer to BUG REPORTING in L<Date::Holidays>

=head1 AUTHOR

Denis Boyun, C<< <denisboyun at gmail.com> >>
Jonas Brømsø, (jonasbn) - C<< <jonasbn@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

L<Date::Holidays> and related modules are (C) by Jonas Brømsø, (jonasbn)
2004-2022

Date-Holidays and related modules are released under the Artistic License 2.0

=cut
