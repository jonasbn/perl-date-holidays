# $Id$

use Module::Build;

Module::Build->new( 
	module_name       => 'Date::Holidays',
	license           => 'perl',
	dist_author       => 'Jonas B. Nielsen, (jonasbn) jonasbn@cpan.org',
	dist_version_from => 'lib/Date/Holidays.pm',
    create_makefile_pl => 'traditional',
	build_requires => {
		'Test::More'          => 0,      #used for unit-tests
		'File::Find'          => 0,      #as above
		'File::Spec'          => 0,      #as above
		'Date::Holidays::DK'  => '0.02', #used for test
    },
    requires => { 
		'Locale::Country'     => 0,      #used for country code validation
		'Carp'                => 0,      #nicer than die :)
		'UNIVERSAL'           => 0,      #used for can
		'DateTime'            => 0,      #new experimental subs
	},
)->create_build_script;
