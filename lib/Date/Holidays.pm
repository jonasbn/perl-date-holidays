package Date::Holidays;

# $Id: Holidays.pm 1337 2004-05-23 15:19:48Z jonasbn $

use strict;
require Exporter;
use vars qw($VERSION);
use Locale::Country;
use UNIVERSAL qw(can);
use Carp;

$VERSION = '0.01';

sub new {
	my ($class, %params) = @_;

	my $self = bless {
		_inner_object => undef,
		_countrycode  => lc($params{'countrycode'}),
	}, ref $class || $class;

	$self->{'_inner_object'} =
		$self->_loader($self->{'_countrycode'});

	return $self;
}

sub holidays {
	my ($self, %params) = @_;

	if (my $sub = $self->{'_inner_object'}->can("holidays")) {
		return &{$sub}(
			$params{'year'}, 
		);

	} else {
	
		my $method = $self->{'_countrycode'}."_holidays";
		my $sub = $self->{'_inner_object'}->can($method);

		if ($sub) {

			if ($self->{'_countrycode' eq 'de'}) {
				return &{$sub}(
					YEAR => $params{'year'},
				);
			} else {
				return &{$sub}(
					$params{'year'}, 
				);
			}

		} else {
			return undef;
		}
	}
}

sub is_holiday {
	my ($self, %params) = @_;

	if (my $sub = $self->{'_inner_object'}->can("is_holiday")) {
		return &{$sub}(
			$params{'year'}, 
			$params{'month'}, 
			$params{'day'}
		);

	} else {
		my $method = "is_".$self->{'_countrycode'}."_holiday";
		my $sub = $self->{'_inner_object'}->can($method);

		if ($sub) {
			return &{$sub}(
				$params{'year'}, 
				$params{'month'}, 
				$params{'day'}
			);
		} else {
			return undef;
		}
	}
}

sub _loader {
	my ($self, $countrycode) = @_;

	unless ($countrycode) {
		croak "No country code specified";
	}

	$countrycode = 'gb' if ($countrycode eq 'uk');

	unless (code2country($countrycode)) {
		croak "$countrycode is not a valid country code";
	}
	my $module;
	if ($countrycode eq 'jp') {
		$module = "Date::Japanese::Holiday";
	} elsif ($countrycode eq 'pt') {
		$module = "Date::Holiday::PT";
	} elsif ($countrycode eq 'gb') {
		$module = "Date::Holidays::UK";
	} else {
		$module = "Date::Holidays::".uc($countrycode);
	}
	
	eval "require $module" || croak "Unable to load module: $module - $!";

	return $module;
}

1;

__END__

=head1 NAME

Date::Holidays - a holidays OOP aggregator and wrapper

=head1 SYNOPSIS

use Date::Holidays;

my $dh = Date::Holidays->new(
	countrycode => 'dk'
);

$dh->is_holiday(
	year  => 2004,
	month => 12,
	day   => 25
);

$dh->holidays(
	year => 2004
);


=head1 DESCRIPTION

These are the methods implemented in this class. They act as wrappers
around the different modules implementing different national holidays, 
and at the same time they provide an OOP interface.

As described below is requires that a certain API is implemented (SEE:
holidays and is_holiday below).

If you are an author who wants to comply to this suggestion, either
look at some of the other modules in the Date::Holidays::* namespace
and Date::Holidays::Abstract - or write me.

=head2 new

This is the constructor. It takes the following parameters:

=over

=item countrycode, two letter unique code representing a country name

Please refer to ISO3166 (or Locale::Country)

=back

The constructor loads the module from Date::Holidays::*, which matches the 
country code.

=head2 holidays

This is a wrapper around the loaded module's B<holidays> method if this is
implemented. If this method is not implemented it trues <countrycode>_holidays.

Takes one argument:

=over

=item year, four digit parameter representing year

=back

=head2 is_holiday

This is yet another wrapper around the loaded module's B<is_holiday>
method if this is implemented. Also if this method is not implemented
it tries is_<countrycode>_holiday.

Takes 3 arguments:

=over

=item year, four digit parameter representing year

=item month, 1-12, representing month

=item day, 1-31, representing day

=back

=head1 SEE ALSO

=over

=item Date::Holidays::DE

=item Date::Holidays::DK

=item Date::Holidays::FR

=item Date::Holidays::UK

=item Date::Holiday::PT

=item Date::Japanese::Holiday

=item Date::Holidays::Abstract

=back

=head1 BUGS

Please report issues via CPAN RT:

  http://rt.cpan.org/NoAuth/Bugs.html?Dist=Date-Holidays

or by sending mail to

  bug-Date-Holidays@rt.cpan.org

=head1 AUTHOR

Jonas B. Nielsen, (jonasbn) - E<lt>jonasbn@cpan.orgE<gt>

=head1 COPYRIGHT

Date-Holidays is (C) by Jonas B. Nielsen, (jonasbn) 2004

Date-Holidays is released under the artistic license

The distribution is licensed under the Artistic License, as specified
by the Artistic file in the standard perl distribution
(http://www.perl.com/language/misc/Artistic.html).

=cut
