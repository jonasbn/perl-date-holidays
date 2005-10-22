package Date::Holidays;

# $Id: Holidays.pm 1597 2005-10-22 05:45:49Z jonasbn $

use strict;
use vars qw($VERSION);
use Locale::Country qw(all_country_codes code2country);
use UNIVERSAL qw(can);
use Carp;
use DateTime;

$VERSION = '0.04';

sub new {
	my ($class, %params) = @_;

	my $self = bless {
		_inner_object => undef,
		_countrycode  => undef,
	}, ref $class || $class;


	if ($params{'countrycode'}) {
		$self->{'_countrycode'} = lc($params{'countrycode'});
		$self->{'_inner_object'} =
			$self->_loader($self->{'_countrycode'});
	}

	return $self;
}

sub holidays {
	my ($self, %params) = @_;

	if (my $sub = $self->{'_inner_object'}->can("holidays")) {
				
		if ($self->{'_countrycode'} eq 'pt') {

			return $self->{'_inner_object'}->holidays($params{'year'});

		} else {
		
			return &{$sub}(
				$params{'year'}, 
			);
		}

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

sub holidays_dt {
	my ($self, %params) = @_;

	my $hashref = $self->holidays(year => $params{'year'});
	my %dts;
	
	foreach my $h (keys %{$hashref}) {
		my ($month, $day) = $h =~ m/^(\d{2})(\d{2})$/;
		my $dt = DateTime->new(
			year  => $params{'year'},
			month => $month,
			day   => $day,
		);		
		$dts{$hashref->{$h}} = $dt;
	}

	return \%dts;

}

sub is_holiday {
	my ($self, %params) = @_;

	if ($params{'countries'} || not $self->{'_countrycode'}) {

		if (not $params{'countries'}) {
			my @countries = all_country_codes;
			$params{'countries'} = \@countries;
		}
		return $self->_check_countries(%params);

	} else {

		#We are are initialized with a national calendar
		if ($self->{'_inner_object'}) {

			#We can is_holiday
			if (my $sub = $self->{'_inner_object'}->can("is_holiday")) {

				#A Portuguese exception
				if ($self->{'_countrycode'} eq 'pt') {
					return $self->{'_inner_object'}->is_holiday(
						$params{'year'}, 
						$params{'month'}, 
						$params{'day'}
					);

				#We have a sub and an other country
				} else {
					return &{$sub}(
						$params{'year'}, 
						$params{'month'}, 
						$params{'day'}
					);
				}

			#We try national calendar specific sub
			} else {
				my $method = "is_".$self->{'_countrycode'}."_holiday";
				my $sub = $self->{'_inner_object'}->can($method);

				#Portuguese exception
				if ($self->{'_countrycode'} eq 'pt') {
					return $self->{'_inner_object'}->$method(
						$params{'year'}, 
						$params{'month'}, 
						$params{'day'}
					);

				#Other countries
				} else {

					#Do we have a sub
					if ($sub) {
						return &{$sub}(
							$params{'year'}, 
							$params{'month'}, 
							$params{'day'}
						);

					#No sub returning undef
					} else {
						carp "Unable to call national calendar module for: ".$self->{'_countrycode'};
						return undef;
					}
				}
			}
		} else {
			#TODO: should we call new?
			carp("No national calendar initialized");
			return undef;
		}
	}
}

sub _check_countries {
	my ($self, %params) = @_;

	my %result = ();

	foreach my $country (@{$params{'countries'}}) {

		my $dh = __PACKAGE__->new(countrycode => $country);
		
		if ($dh->{'_inner_object'}) {
			my $r = $dh->is_holiday(
				year  => $params{'year'}, 
				month => $params{'month'}, 
				day   => $params{'day'}
			);

			if ($r) {
				$result{$country} = $r;
			} else {
				$result{$country} = '';
			}
		} else {
			$result{$country} = undef;
		}
	}

	return \%result;
}

sub is_holiday_dt {
	my ($self, $dt) = @_;

	return $self->is_holiday(
		year  => $dt->year,
		month => $dt->month,
		day   => $dt->day,
	);
}

sub _loader {
	my ($self, $countrycode) = @_;

	unless ($countrycode) {
		carp "No country code specified";
		return undef;
	}

	$countrycode = 'gb' if ($countrycode eq 'uk');

	unless (code2country($countrycode)) {
		carp "$countrycode is not a valid country code";
		return undef;
	}
	my $module;
	if ($countrycode eq 'jp') {
		return undef;
		#$module = "Date::Japanese::Holiday";
	} elsif ($countrycode eq 'gb') {
		$module = "Date::Holidays::UK";
	} else {
		$module = "Date::Holidays::".uc($countrycode);
	}
	
	eval "require $module";
	
	if ($@) {
		carp "Unable to locate module: $module\n";
		return undef;
	}

	return $module;
}

1;

__END__

=head1 NAME

Date::Holidays - a Date::Holidays::* OOP wrapper

=head1 SYNOPSIS

	use Date::Holidays;

	my $dh = Date::Holidays->new(
		countrycode => 'dk'
	);

	$holidayname = $dh->is_holiday(
		year  => 2004,
		month => 12,
		day   => 25
	);

	$hashref = $dh->holidays(
		year => 2004
	);

	
	$holidays_hashref = $dh->is_holiday(
		year      => 2004,
		month     => 12,
		day       => 25,
		countries => ['se', 'dk', 'no'],
	);

	foreach my $country (keys %{$holidays_hashref}) {
		print $holidays_hashref->{$country}."\n";
	}


	$holidays_hashref = $dh->is_holiday(
		year      => 2004,
		month     => 12,
		day       => 25,
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

This is the constructor. It takes the following parameter:

=over

=item countrycode (OPTIONAL, see below), two letter unique code representing a 
country name.  Please refer to ISO3166 (or L<Locale::Country>)

=back

The constructor loads the module from Date::Holidays::*, which matches the 
country code.

=head2 holidays

This is a wrapper around the loaded module's B<holidays> method if this is
implemented. If this method is not implemented it tries <countrycode>_holidays.

Takes one named argument:

=over

=item year, four digit parameter representing year

=back

=head2 holidays_dt *EXPERIMENTAL*

This method is similar to holidays. It takes one named argument b<year>.

The result is a hashref just as for B<holidays>, but instead the names
of the holidays are used as keys and the values are DateTime objects.

=head2 is_holiday

This is yet another wrapper around the loaded module's B<is_holiday>
method if this is implemented. Also if this method is not implemented
it tries is_<countrycode>_holiday.

Takes 3 arguments:

=over

=item year, four digit parameter representing year

=item month, 1-12, representing month

=item day, 1-31, representing day

=item countries (OPTIONAL), a list of ISO3166 country codes

=back

is_holiday returns the name of a holiday is present in the country specified by 
the country code provided to the Date::Holidays constructor.

If however the Date::Holidays object was not provided with a country code, all
known countries are tested for a holiday on the specified date, unless the 
countries parameter specified a subset of countries to test.

In the case where a set of countries are tested the return value from the method
is a hashref with the country codes as keys and the values as the result.

=over

=item undef if the country has no module or the data could not be obtained

=item a name of the holiday if a holiday is present

=item an empty string if the a module was located but the day is not a holiday

=back

=head2 is_holiday_dt *EXPERIMENTAL*

This method is similar to is_holiday, but instead of 3 separate
arguments is only takes a single argument, a DateTime object.

Return 1 for true if the object is a holiday and 0 for false if not.

=head1 SEE ALSO

=over

=item L<Date::Holidays::DE>

=item L<Date::Holidays::DK>

=item L<Date::Holidays::FR>

=item L<Date::Holidays::NO>

=item L<Date::Holiday::PT>

=item L<Date::Holidays::UK>

=item L<Date::Japanese::Holiday>

=item L<Date::Holidays::Abstract>

=item L<Date::Holidays::Super>

=item L<DateTime>

=back

=head1 BUGS

Please report issues via CPAN RT:

  http://rt.cpan.org/NoAuth/Bugs.html?Dist=Date-Holidays

or by sending mail to

  bug-Date-Holidays@rt.cpan.org

=head1 ACKNOWLEDGEMENTS

=over

=item * COG (Jose Castro)

=item * RJBS (Ricardo Signes)

=item * MRAMBERG (Marcus Ramberg)

=item * BORUP (Christian Borup)

=item * shild on use.perl.org

=back

=head1 AUTHOR

Jonas B. Nielsen, (jonasbn) - E<lt>jonasbn@cpan.orgE<gt>

=head1 COPYRIGHT

Date-Holidays is (C) by Jonas B. Nielsen, (jonasbn) 2004-2005

Date-Holidays is released under the artistic license

The distribution is licensed under the Artistic License, as specified
by the Artistic file in the standard perl distribution
(http://www.perl.com/language/misc/Artistic.html).

=cut
