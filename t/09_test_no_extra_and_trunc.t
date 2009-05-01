use strict;
use warnings;

use Test;
use Term::ANSIColorx::AutoFilterFH qw(filtered_handle);

plan tests => 1;

open FILE, ">TEST" or die $!;
eval { my $colored = filtered_handle(\*FILE => (qr(test1) => 'red'), ("test2" => "blood") ) };
ok( $@ =~ m/blood/ );

__END__

print $colored "this is a test: test1, test2\n";
close FILE;

open FILE, "TEST" or die $!;
my $contents = do {local $/; <FILE>};

ok( $contents =~ m/\e\[1;34mtest1\e\[0?m/ );
ok( $contents =~ m/\e\[31mtest2\e\[0?m/ );
