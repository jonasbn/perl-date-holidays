package Date::Holidays::Exception::AdapterInitialization;

# $Id: AdapterInitialization.pm 1742 2007-02-22 19:47:55Z jonasbn $

use strict;
use warnings;
use vars qw($VERSION);

use base 'Date::Holidays::Exception::AdapterLoad';
use overload ('""' => 'stringify');

$VERSION = '0.17';

1;

__END__

=head1 NAME

Date::Holidays::Exception::AdapterInitialization - an adapter exception class

=head1 VERSION

This POD describes version 0.01 of Date::Holidays::Exception::AdapterInitialization

=head1 SYNOPSIS

    use Date::Holidays::Exception::AdapterInitialization;
    
    try {
        #Initialize adapter
        
        throw Date::Holidays::Exception::AdapterInitialization('Unable to initialize adapter');
    }
    catch Date::Holidays::Exception::AdapterLoad with {
        my $E = shift;
        
        throw Date::Holidays::Exception::AdapterInitialization($E->{-text}); 
    } ...    
    
    ...
    
    catch Date::Holidays::Exception::AdapterInitialization with {
        my $E = shift;
        
        print STDERR $E->{-text}; #Unable to initialize adapter
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

