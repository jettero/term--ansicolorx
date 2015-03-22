use strict;
use warnings;

use Test;

my $tests = 4;
plan tests => $tests;

open FILE, "|$^X -CA bin/hi 'test\\d+' _hashed_ test: ocean >TEST" or die $!;
print FILE "test: test$_\n" for 1 .. $tests;
print FILE "test: test3 test4 test1 test2\n";
close FILE;

my @t;
open FILE, 'TEST' or die $!;
for( 1 .. $tests ) {
    my $t = <FILE>;
    chomp $t;
    $t =~ s/.*test:\S*\s//;
    push @t, $t;
}

my $last = <FILE>;
chomp $last;

close FILE;

for( @t ) {
    ok( $last =~ m/\Q$_\E/ );
}
