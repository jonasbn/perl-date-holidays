package Date::Holidays::Adapter;

# $Id: Adapter.pm 1742 2007-02-22 19:47:55Z jonasbn $

use strict;
use warnings;
use Carp;
use Error qw(:try);
use Module::Load qw(load);
use Locale::Country;

use Date::Holidays::Exception::AdapterLoad;
use Date::Holidays::Exception::AdapterInitialization;
use Date::Holidays::Exception::UnsupportedMethod;

use vars qw($VERSION);

$VERSION = '0.17';

sub new {
    my ($class, %params) = @_;
    
    my $self = bless {
        _countrycode => lc $params{countrycode},
        _adaptee     => undef,
    }, $class || ref $class;

    try {
        my $adaptee = $self->_fetch(\%params);
        
        if ($adaptee) {
            $self->{_adaptee} = $adaptee;
        } else {
            throw Date::Holidays::Exception::AdapterInitialization('Unable to initialize adaptee class');
        }
    }
    catch Date::Holidays::Exception::AdapterLoad with {
        my $E = shift;
        throw Date::Holidays::Exception::AdapterInitialization($E->{-text});
    }
    otherwise {
        my $E = shift;
        $E->throw;
    };

    return $self;
}

sub holidays {
    my ($self, %params) = @_;

    my $r;
    try {
        my $method = 'holidays';    
        my $sub = $self->{_adaptee}->can('holidays');
    
        if (! $sub) {
            $method = "$self->{_countrycode}_holidays";
            $sub = $self->{_adaptee}->can($method);
        } 

        if ($sub) {
            $r = &{$sub}($params{'year'});
        }
    }
    catch Date::Holidays::Exception::UnsupportedMethod with {
        my $E = shift;
        $E->throw();
    };
    
    return $r;
}

sub is_holiday {
    my ($self, %params) = @_;

    my $r;
    try {
        my $method = 'is_holiday';    
        my $sub = $self->{_adaptee}->can('is_holiday');
        
        if (! $sub) {
            $method = "is_$self->{_countrycode}_holiday";
            $sub = $self->{_adaptee}->can($method);
        } 
    
        if ($sub) {
            $r = &{$sub}($params{'year'}, $params{'month'}, $params{'day'});
        }
    }
    catch Date::Holidays::Exception::UnsupportedMethod with {
        my $E = shift;
        $E->throw();
    };
    
    return $r;
}

sub _load {
    my ($self, $module) = @_;
    
    eval { load $module; }; #From Module::Load
    
    if ($@) {
        throw Date::Holidays::Exception::AdapterLoad("Unable to load: $module");    
    }
    
    return $module;
}

sub _fetch {
    my ( $self, $params ) = @_;

    if ( !$self->{_countrycode} ) {
        croak "No country code specified";
    }

    if ( !$params->{nocheck} ) {
        if ( !code2country($self->{_countrycode}) ) { #from Locale::Country
            carp "$self->{_countrycode} is not a valid country code";
            return;
        }
    }

    my $module;
    try {
        $module = 'Date::Holidays::' . uc $self->{_countrycode};
        $self->_load($module);
    }
    catch Date::Holidays::Exception::AdapterLoad with {
        my $E = shift;
        $E->throw;    
    }
    otherwise {
        my $E = shift;
        $E->throw;
    };

    return $module;
}

1;

__END__

=head1 NAME

Date::Holidays::Adapter - an adapter class for Date::Holidays::* modules

=head1 SYNOPSIS

    my $adapter = Date::Holidays::Adapter->new(countrycode => 'NO');
    
    my ($year, $month, $day) = (localtime)[ 5, 4, 3 ];
    $year  += 1900;
    $month += 1;
  
    print "Woohoo" if $adapter->is_holiday( year => $year, month => $month, day => $day );

    my $hashref = $adapter->holidays(year => $year);
    printf "Dec. 24th is named '%s'\n", $hashref->{'1224'}; #christmas I hope

=head1 VERSION

This POD describes version 0.02 of Date::Holidays::Adapter

=head1 DESCRIPTION

The is the SUPER adapter class. All of the adapters in the distribution of
Date::Holidays are subclasses of this class. (SEE also L<Date::Holidays>).

The SUPER adapter class is at the same time a generic adapter. It attempts to
adapt to the most used API for modules in the Date::Holidays::* namespace. So
it should only be necessary to implement adapters to the exceptions to modules
not following the the defacto standard or suffering from other local
implementations.

=head1 SUBROUTINES/METHODS

The public methods in this class are all expected from the adapter, so it
actually corresponds with the abstract is outlined in L<Date::Holidays::Abstract>.

Not all methods/subroutines may be implemented in the adaptee classes, the
adapters attempt to make the adaptee APIs adaptable where possible. This is
afterall the whole idea of the Adapter Pattern, but apart from making the
single Date::Holidays::* modules uniform towards the clients and
L<Date::Holidays> it is attempted to make the multitude of modules uniform in
the extent possible.

=head2 new

The constructor, takes a single named argument, B<countrycode>

=head2 is_holiday

The B<holidays> method, takes 3 named arguments, B<year>, B<month> and B<day>

returns an indication of whether the day is a holiday in the calendar of the
country referenced by B<countrycode> in the call to the constructor B<new>.

=head2 holidays

The B<holidays> method, takes a single named argument, B<year>

returns a reference to a hash holding the calendar of the country referenced by
B<countrycode> in the call to the constructor B<new>.

The calendar will spand for a year and the keys consist of B<month> and B<day>
concatenated.

=head1 DEVELOPING A DATE::HOLIDAYS::* ADAPTER

If you want to develop an adapter compatible with interface specified in this
class. You have to implement the following 3 methods:

=over

=item new

A constructor, taking a single argument a two-letter countrycode
(SEE: L<Locale::Country>)

You can also inherit the one implemented and offered by this class

B<NB>If inheritance is used, please remember to overwrite the two following
methods, if applicable.

=item holidays

This has to follow the API outlined in SUBROUTINES/METHODS.

For the adaptee class anything goes, hence the use of an adapter.

Please refer to the DEVELOPER section in L<Date::Holidays> about contributing to
the Date::Holidays::* namespace or attempting for adaptability with
L<Date::Holidays>.

=item is_holiday

This has to follow the API outlined in SUBROUTINES/METHODS.

For the adaptee class anything goes, hence the use of an adapter.

Please refer to the DEVELOPER section in L<Date::Holidays> about contributing to
the Date::Holidays::* namespace or attempting for adaptability with
L<Date::Holidays>.

=back

Apart from the methods described above you can also overwrite the _fetch method
in this class, This is used if your module is not a part of the
Date::Holidays::* namespace or the module bears a name which is not ISO3166
compliant.

See also:

=over

=item * L<Date::Holidays::UK>

=item * L<Date::Japanese::Holiday>

=back

=head1 DIAGNOSTICS

=over

=item * L<Date::Holidays::Exception::AdapterLoad>

Exception thrown in the case where the B<_load> method is unable to load a
requested adapter module.

The exception is however handled internally.

=item * L<Date::Holidays::Exception::AdapterInitialization>

Exception thrown in the case where the B<_new> method is unable to
initialize a requested adapter module.

=item * L<Date::Holidays::Exception::UnsupportedMethod>

Exception thrown in the case where the loaded and initialized module does not
support the called method. (SEE: METHODS/SUBROUTINES).

=back

=head1 DEPENDENCIES

=over

=item * L<Carp>

=item * L<Error>

=item * L<Module::Load>

=item * L<UNIVERSAL>

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

L<Date::Holidays> and related modules are (C) by Jonas B. Nielsen, (jonasbn)
2004-2007

L<Date::Holidays> and related modules are released under the artistic license

The distribution is licensed under the Artistic License, as specified
by the Artistic file in the standard perl distribution
(http://www.perl.com/language/misc/Artistic.html).

=cut
