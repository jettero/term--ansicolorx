use strict;
use warnings;

use Test;

plan tests => 1;

open FILE, "|$^X -CA bin/hi 'test\\d+' _hashed_ test: ocean >TEST" or die $!;
print FILE "test: test1 test2\n";
close FILE;

open FILE, "TEST" or die $!;
my $contents = <FILE>;
close FILE;

ok( warn "contents; $contents" );
