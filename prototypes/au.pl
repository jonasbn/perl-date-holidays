use strict;
use warnings;
use Time::Local;

print _compute_agfest(2015);

exit 0;

sub _compute_agfest {    # friday following first thursday in may
    my ($year)      = @_;
    my ($day)       = 1;
    my ($month)     = 4;
    my ($date)      = Time::Local::timelocal( 0, 0, 0, $day, $month, $year );
    my ($thursdays) = 0;
    my ( $sec, $min, $hour, $wday, $yday, $isdst );

    while ( $thursdays < 1 ) {
        ( $sec, $min, $hour, undef, undef, undef, $wday, $yday, $isdst ) = localtime($date);

        if ( $wday == 4 ) {
            $thursdays += 1;
        }
        if ( $thursdays < 1 ) {
            $day += 1;
            $date = Time::Local::timelocal( 0, 0, 0, $day, $month, $year );
        }
    }
    return ( sprintf( "%02d%02d", ( $month + 1 ), ( $day + 1 ) ) );
}
