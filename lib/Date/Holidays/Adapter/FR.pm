package Date::Holidays::Adapter::FR;

# $Id: FR.pm 1742 2007-02-22 19:47:55Z jonasbn $

use strict;
use warnings;
use vars qw($VERSION);
use Error qw(:try);

use base 'Date::Holidays::Adapter';
use Date::Holidays::Exception::UnsupportedMethod;

$VERSION = '0.17';

sub holidays {
    throw Date::Holidays::Exception::UnsupportedMethod('is_holiday');
    return;
}

sub is_holiday {
    my ($self, %params) = @_;
    
    my $sub = $self->{_adaptee}->can('is_fr_holiday');

    if ($sub) {
        return &{$sub}($params{'year'}, $params{'month'}, $params{'day'});
    } else {
        return;    
    }
}

1;

__END__

=head1 NAME

Date::Holidays::Adapter::FR - an adapter class for Date::Holidays::FR

=head1 VERSION

This POD describes version 0.01 of Date::Holidays::Adapter::FR

=head1 DESCRIPTION

The is the adapter class for L<Date::Holidays::FR>.

=head1 SUBROUTINES/METHODS

=head2 new

The constructor is inherited from L<Date::Holidays::Adapter>

=head2 new

The constructor, takes a single named argument, B<countrycode>

The constructor is inherited from L<Date::Holidays::Adapter>

=head2 is_holiday

The B<holidays> method, takes named 3 arguments, B<year>, B<month> and B<day>

Returns an indication of whether the day is a holiday in the calendar of the
country referenced by B<countrycode> in the call to the constructor B<new>.

=head2 holidays

Not implemented in L<Date::Holidays::FR>, calls to this throw the
L<Date::Holidays::Exception::UnsupportedMethod>

=head1 DIAGNOSTICS

=over

=item * L<Date::Holidays::Exception::AdapterLoad>

This exception is thrown when L<Date::Holidays::Adapter> attempts to load an
actual adapter implementation. This exception is recoverable to the extend
that is caught and handled internally.

When caught the SUPER adapter is attempted loaded, L<Date::Holidays::Adapter>
if this however fails L<Date::Holidays::Exception::SuperAdapterLoad> it thrown
see below.

=item * L<Date::Holidays::Exception::AdapterInitialization>

This exception is thrown when in was not possible to load either a
implementation of a given adapter, or the SUPER adapter
L<Date::Holidays::Adapter>.

=item * L<Date::Holidays::Exception::NoCountrySpecified>

The exception is thrown if a country code is provided, which is not listed
in L<Locale::Country>, which lists ISO 3166 codes, which is the unique 2
character strings assigned to each country in the world.

=item * L<Date::Holidays::Exception::UnsupportedMethod>

Exception thrown in the case where the loaded and initialized module does not
support the called method. (SEE: METHODS/SUBROUTINES).

=back

=head1 DEPENDENCIES

=over

=item * L<Date::Holidays::FR>

=item * L<Date::Holidays::Adapter>

=item * L<Date::Holidays::Exception::UnsupportedMethod>

=item * L<Date::Holidays::Exception::InvalidCountryCode>

=item * L<Date::Holidays::Exception::NoCountrySpecified>

=item * L<Date::Holidays::Exception::UnsupportedMethod>

=item * L<Error>

=item * L<UNIVERSAL>

=back

=head1 INCOMPATIBILITIES

Please refer to INCOMPATIBILITIES in L<Date::Holidays>

=head1 BUGS AND LIMITATIONS

B<holidays> or similar method is not implemented in L<Date::Holidays::FR> as
of version 0.02.

Additional methods of L<Date::Holidays::FR> are not supported currently.

Please refer to BUGS AND LIMITATIONS in L<Date::Holidays>

=head1 BUG REPORTING

Please report issues via CPAN RT:

  http://rt.cpan.org/NoAuth/Bugs.html?Dist=Date-Holidays

or by sending mail to

  bug-Date-Holidays@rt.cpan.org

=head1 AUTHOR

Jonas B. Nielsen, (jonasbn) - C<< <jonasbn@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

L<Date::Holidays> and related modules are (C) by Jonas B. Nielsen, (jonasbn)
2004-2007

L<Date::Holidays> and related modules are released under the artistic license

The distribution is licensed under the Artistic License, as specified
by the Artistic file in the standard perl distribution
(http://www.perl.com/language/misc/Artistic.html).

=cut
