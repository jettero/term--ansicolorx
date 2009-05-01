

use strict;
use warnings;

use Test;
use Term::ANSIColorx::ExtraColors qw(:constants);

plan tests => 2;

my $string = BLOOD . "red" . SKY . "blue";
ok( $string =~ m/\e\[31m/ );
ok( $string =~ m/\e\[1;34m/ );
