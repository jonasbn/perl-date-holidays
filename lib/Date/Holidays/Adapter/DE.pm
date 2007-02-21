package Date::Holidays::Adapter::DE;

# $Id: DE.pm 1736 2007-02-21 22:18:18Z jonasbn $

use strict;
use warnings;
use Error qw(:try);
use base 'Date::Holidays::Adapter';

use vars qw($VERSION);

$VERSION = '0.01';

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
    throw Date::Holidays::Exception::UnsupportedMethod('is_holiday');
    return;
}

1;

__END__

=head1 NAME

Date::Holidays::Adapter - an adapter class for Date::Holidays::* modules

=head1 VERSION

This POD describes version 0.01 of Date::Holidays::Adapter

=head1 DESCRIPTION

The is the SUPER adapter class. All of the adapters in the distribution of
Date::Holidays are subclasses of this particular class. L<Date::Holidays>

=head1 SUBROUTINES/METHODS

=head2 new

The constructor is inherited from L<Date::Holidays::Adapter>

=head2 is_holiday

=head2 holidays

=head1 DIAGNOSTICS

TODO...

=head1 DEPENDENCIES

=over

=item L<Date::Holidays>

=item L<Carp>

=item L<Error>

=item L<Module::Load>

=item L<UNIVERSAL>

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
