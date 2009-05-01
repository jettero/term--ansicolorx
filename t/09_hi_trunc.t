use strict;
use warnings;

use Test;
use Term::ANSIColorx::AutoFilterFH qw(filtered_handle set_truncate);

plan tests => 1;

open FILE, "|$^X ./hi -t 10 test1 blue >TEST" or die $!;
print FILE "test: test1 test2\n";
close FILE;

open FILE, "TEST" or die $!;
my $contents = <FILE>;
close FILE;

ok( length($contents), 11 );
