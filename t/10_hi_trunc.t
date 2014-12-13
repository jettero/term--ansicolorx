use strict;
use warnings;

use Test;

plan tests => 2;

open FILE, "|$^X -CA bin/hi -t 80 test1 bold-blue >TEST" or die $!;
my $string = "test1 test2" x 25;
print FILE "test: $string\n";
close FILE;

open FILE, "TEST" or die $!;
my $contents = <FILE>;
close FILE;

ok( length($contents), 81 );
ok( $contents, qr/\e\[1(?:m\e\[|;)34mtest1\e\[0?m/ );
