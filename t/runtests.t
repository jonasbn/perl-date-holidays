#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib", "$Bin/../t", "$Bin/t", "$Bin";

#use Test::Class::Date::Holidays::Local;
use Test::Class::Date::Holidays::Adapter;
#use Test::Class::Date::Holidays;

use Test::Class::Date::Holidays::Produceral;
use Test::Class::Date::Holidays::Supered;
use Test::Class::Date::Holidays::Abstracted;
use Test::Class::Date::Holidays::Polymorphic;
use Test::Class::Date::Holidays::Nonpolymorphic;

{
    use Test::Class::Date::Holidays::AT;
    my $rv = eval { require Date::Holidays::AT };
    Test::Class::Date::Holidays::AT->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::AT not installed'
    );
}

{
    use Test::Class::Date::Holidays::AU;
    my $rv = eval { require Date::Holidays::AU };
    Test::Class::Date::Holidays::AU->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::AU not installed'
    );
}

{
    use Test::Class::Date::Holidays::BY;
    my $rv = eval { require Date::Holidays::BY };
    Test::Class::Date::Holidays::BY->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::BY not installed'
    );
}

{
    use Test::Class::Date::Holidays::BR;
    my $rv = eval { require Date::Holidays::BR };
    Test::Class::Date::Holidays::BR->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::BR not installed'
    );
}

#{
#    use Test::Class::Date::Holidays::CA;
#    my $rv = eval { require Date::Holidays::CA };
#    Test::Class::Date::Holidays::CA->SKIP_CLASS(
#        $rv ? 0 : 'Date::Holidays::CA not installed'
#    );
#}

#{
#    use Test::Class::Date::Holidays::CN;
#    my $rv = eval { require Date::Holidays::CN };
#    Test::Class::Date::Holidays::CN->SKIP_CLASS(
#        $rv ? 0 : 'Date::Holidays::CN not installed'
#    );
#}

{
    use Test::Class::Date::Holidays::CZ;
    my $rv = eval { require Date::Holidays::CZ };
    Test::Class::Date::Holidays::CZ->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::CZ not installed'
    );
}

{
    use Test::Class::Date::Holidays::DE;
    my $rv = eval { require Date::Holidays::DE };
    Test::Class::Date::Holidays::DE->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::DE not installed'
    );
}

{
    use Test::Class::Date::Holidays::DK;
    my $rv = eval { require Date::Holidays::DK };
    Test::Class::Date::Holidays::DK->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::DK not installed'
    );
}

{
    use Test::Class::Date::Holidays::ES;
    my $rv = eval { require Date::Holidays::ES };
    Test::Class::Date::Holidays::ES->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::ES not installed'
    );
}

{
    use Test::Class::Date::Holidays::FR;
    my $rv = eval { require Date::Holidays::FR };
    Test::Class::Date::Holidays::FR->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::FR not installed'
    );
}

{
    use Test::Class::Date::Holidays::GB;
    my $rv = eval { require Date::Holidays::GB };
    Test::Class::Date::Holidays::GB->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::GB not installed'
    );
}

{
    use Test::Class::Date::Holidays::KR;
    my $rv = eval { require Date::Holidays::KR };
    Test::Class::Date::Holidays::KR->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::KR not installed'
    );
}

{
    use Test::Class::Date::Holidays::KZ;
    my $rv = eval { require Date::Holidays::KZ };
    Test::Class::Date::Holidays::KZ->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::KZ not installed'
    );
}

{
    use Test::Class::Date::Holidays::NO;
    my $rv = eval { require Date::Holidays::NO };
    Test::Class::Date::Holidays::NO->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::NO not installed'
    );
}

#{
#    use Test::Class::Date::Holidays::NZ;
#    my $rv = eval { require Date::Holidays::NZ };
#    Test::Class::Date::Holidays::NZ->SKIP_CLASS(
#        $rv ? 0 : 'Date::Holidays::NZ not installed'
#    );
#}

{
    use Test::Class::Date::Holidays::PL;
    my $rv = eval { require Date::Holidays::PL };
    Test::Class::Date::Holidays::PL->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::PL not installed'
    );
}

{
    use Test::Class::Date::Holidays::PT;
    my $rv = eval { require Date::Holidays::PT };
    Test::Class::Date::Holidays::PT->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::PT not installed'
    );
}

{
    use Test::Class::Date::Holidays::RU;
    my $rv = eval { require Date::Holidays::RU };
    Test::Class::Date::Holidays::RU->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::RU not installed'
    );
}

{
    use Test::Class::Date::Holidays::SK;
    my $rv = eval { require Date::Holidays::SK };
    Test::Class::Date::Holidays::SK->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::SK not installed'
    );
}

{
    use Test::Class::Date::Holidays::UK;
    my $rv = eval { require Date::Holidays::UK };
    Test::Class::Date::Holidays::UK->SKIP_CLASS(
        $rv ? 0 : 'Date::Holidays::UK not installed'
    );
}

#{
#    use Test::Class::Date::Holidays::USFederal;
#    my $rv = eval { require Date::Holidays::USFederal };
#    Test::Class::Date::Holidays::USFederal->SKIP_CLASS(
#        $rv ? 0 : 'Date::Holidays::USFederal not installed'
#    );
#}

{
    use Test::Class::Date::Japanese::Holiday;
    my $rv = eval { require Date::Japanese::Holiday };
    Test::Class::Date::Japanese::Holiday->SKIP_CLASS(
        $rv ? 0 : 'Date::Japanese::Holiday not installed'
    );
}

Test::Class->runtests();
