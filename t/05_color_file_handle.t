use strict;
use warnings;

use Test;
use Term::ANSIColorx::ColorNicknames;
use Term::ANSIColorx::AutoFilterFH qw(filtered_handle);

plan tests => 2;

open FILE, ">TEST" or die $!;
my $colored = filtered_handle(\*FILE => (qr(test1) => 'sky'), ("test2" => "blood") );
print $colored "this is a test: test1, test2\n";
close FILE;

open FILE, "TEST" or die $!;
my $contents = do {local $/; <FILE>};

ok( $contents =~ m/\e\[1;34mtest1\e\[0?m/ );
ok( $contents =~ m/\e\[31mtest2\e\[0?m/ );
