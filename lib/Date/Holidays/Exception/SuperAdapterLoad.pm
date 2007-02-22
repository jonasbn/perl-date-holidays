package Date::Holidays::Exception::SuperAdapterLoad;

# $Id: SuperAdapterLoad.pm 1742 2007-02-22 19:47:55Z jonasbn $

use strict;
use warnings;
use vars qw($VERSION);

use base 'Date::Holidays::Exception::AdapterLoad';
use overload ('""' => 'stringify');

$VERSION = '0.01';

1;

__END__

=head1 NAME

Date::Holidays::Exception::SuperAdapterLoad - an adapter exception class

=head1 VERSION

This POD describes version 0.01 of Date::Holidays::Exception::SuperAdapterLoad

=head1 SYNOPSIS

    use Date::Holidays::Exception::SuperAdapterLoad;
    
    try {
        #Load adapter
        
        throw Date::Holidays::Exception::SuperAdapterLoad('Unable to load adapter');
    } ...
    
    
    ...
    
    catch Date::Holidays::Exception::SuperAdapterLoad with {
        my $E = shift;
        
        print STDERR $E->{-text}; #Unable to load adapter
    } ...
    

=head1 DESCRIPTION

This is an exception for use in L<Date::Holidays> and related modules.

=head1 SUBROUTINES/METHODS

=head2 new

Takes a text string

Inherited from L<Date::Holidays::Exception::AdapterLoad>

=head1 DIAGNOSTICS

This is a diagnostic class.

=head1 DEPENDENCIES

=over

=item * L<Date::Holidays::Exception::AdapterLoad>

=item * L<Error>

=back

=head1 INCOMPATIBILITIES

Please refer to INCOMPATIBILITIES in L<Date::Holidays>

=head1 BUGS AND LIMITATIONS

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

