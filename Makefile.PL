# Makefile.PL for Date-Holidays

# $Id: Makefile.PL 1338 2004-05-23 15:25:09Z jonasbn $

use ExtUtils::MakeMaker;

WriteMakefile(
	'AUTHOR'        => 'Jonas B. Nielsen, (jonasbn) jonasbn@cpan.org',
    'NAME'	        => 'Date::Holidays',
    'VERSION_FROM'  => 'lib/Date/Holidays.pm', # finds $VERSION
	'PREREQ_PM' => {
		'Test::More'          => 0,      #used for unit-tests
		'Test::Pod'           => '0.95', #used for pod test
		'Test::Pod::Coverage' => '0.08', #used for pod test also
		'File::Find'          => 0,      #as above
		'File::Spec'          => 0,      #as above
		'Locale::Country'     => 0,      #use for country code validation
		'Carp'                => 0,      #Nicer than die :)
		'UNIVERSAL'           => 0,      #use for can
		'Exporter'            => 0,      #used for exporting
		'Date::Holidays::DK'  => '0.02', #used for test
	}
);
