package Date::Holidays::Adapter;

# $Id: Adapter.pm 1731 2007-02-21 09:54:04Z jonasbn $

use strict;
use warnings;
use Carp;
use Error qw(:try);
use Module::Load;
use Locale::Country;
use Date::Holidays::Exception::AdapterLoad;
use Date::Holidays::Exception::AdapterInitialization;

use vars qw($VERSION);

$VERSION = '0.01';

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

    my $method = 'holidays';    
    my $sub = $self->{_adaptee}->can('holidays');
    
    if (! $sub) {
        $method = "$self->{_countrycode}_holidays";
        $sub = $self->{_adaptee}->can($method);
    } 

    if ($sub) {
        return &{$sub}($params{'year'});
    } else {
        carp "unsupported method $method";
        return;
    }
}

sub is_holiday {
    my ($self, %params) = @_;

    my $method = 'is_holiday';    
    my $sub = $self->{_adaptee}->can('is_holiday');
    
    if (! $sub) {
        $method = "is_$self->{_countrycode}_holiday";
        $sub = $self->{_adaptee}->can($method);
    } 

    if ($sub) {
        return &{$sub}($params{'year'}, $params{'month'}, $params{'day'});
    } else {
        carp "unsupported method $method";
        return;
    }
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

=head1 VERSION

This POD describes version 0.01 of Date::Holidays::Adapter

=head1 DESCRIPTION

The is the SUPER adapter class. All of the adapters in the distribution of
Date::Holidays are subclasses of this particular class. L<Date::Holidays>

=head1 SUBROUTINES/METHODS

The public methods in this class are all expected from the adapter, so it
actually corresponds with the abstract outlines in L<Date::Holidays::Abstract>.

Not all methods/subroutines may be implemented in the adaptee classes, the
adapters attempt to make the adaptee APIs adaptable where possible. This is
afterall the whole idea of the Adapter Pattern, but apart from making the
single Date::Holidays::* modules uniform towards the clients and
L<Date::Holidays> it is attempted to make the multitude of modules uniform in
the extent possible.

=head2 new

The constructor

=head2 is_holiday

=head2 holidays

=head1 DEVELOPING A DATE::HOLIDAYS::* ADAPTER

=head1 DIAGNOSTICS

=over

=item L<Date::Holidays::Exception::AdapterLoad>

The exception is thrown in the case where the B<_load> method is unable to
load a requested adapter module.

=back

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
