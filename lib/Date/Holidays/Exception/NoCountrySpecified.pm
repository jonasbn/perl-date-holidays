package Date::Holidays::Exception::NoCountrySpecified;

# $Id: NoCountrySpecified.pm 1736 2007-02-21 22:18:18Z jonasbn $

use strict;
use warnings;

use base 'Date::Holidays::Exception::AdapterLoad';
use overload ('""' => 'stringify');

1;

=head1 NAME

Date::Holidays::Exception::InvalidCountryCode - a Date::Holidays exception class

=head1 VERSION

This POD describes version 0.01 of Date::Holidays::Exception::AdapterInitialization

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head1 DIAGNOSTICS

TODO...

=head1 DEPENDENCIES

=over

=item L<Error>

=back

=head1 INCOMPATIBILITIES

Please refer to INCOMPATIBILITIES in L<Date::Holidays>

=head1 BUGS AND LIMITATIONS

Please refer to BUGS AND LIMITATIONS in L<Date::Holidays>

=head1 BUG REPORTING

Please refer to BUG REPORTING in L<Date::Holidays>

=head1 AUTHOR

Jonas B. Nielsen, (jonasbn) - C<< <jonasbn@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Date-Holidays and related modules are (C) by Jonas B. Nielsen, (jonasbn)
2004-2007

Date-Holidays and related modules are released under the artistic license

The distribution is licensed under the Artistic License, as specified
by the Artistic file in the standard perl distribution
(http://www.perl.com/language/misc/Artistic.html).

=cut


