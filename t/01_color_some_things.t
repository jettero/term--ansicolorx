

use strict;
use warnings;

use Test;
use Term::ANSIColorx::ExtraColors;
use Term::ANSIColor qw(:constants);

plan tests => 2;

my $string = BLOOD . "red" . SKY . "blue";
ok( $string =~ m/\e\[31m/ );
ok( $string =~ m/\e\[1;34m/ );
