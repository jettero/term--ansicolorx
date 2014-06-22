
use strict;
no strict 'refs';

use Test;
use Term::ANSIColorx::ColorNicknames;

my %todo = (
    colored_1 => [  [["bold","blue"],"this","that"] => [['sky'],'this','that']       ],
    colored_2 => [  ["this that", "bold", "blue"]   => ["this that", "sky"]          ],
    colored_3 => [  ["this that", "carina round"]   => ["this that", "carina round"] ],
    # Carina Round isn't a color … :/

    color_1 => [ ['blue'], ['blue'] ],
    color_2 => [ ['bold blue'], ['sky'] ],
    color_3 => [ ['bold blue on_white'], ['bold-sky-on-white'] ],
    color_3 => [ ['bold black'], ['black'] ],
    color_3 => [ ['black'], ['dark black'] ],
    color_4 => [ ['maynard james keenan'], ['maynard james keenan'] ],
    # Wait, MJK isn't a color either.  Donkey Punch the Night Away.

    uncolor    => [ ["\e[1;34m"], ["\e[1;34m"] ],
    colorstrip => [ ["\e[1;34m"], ["\e[1;34m"] ],

    colorvalid => [ ["blue"], ["sky"] ],
);

plan tests => 2 * (keys %todo);

for my $key (keys %todo) {
    my $f = $key; $f =~ s/_\d+$//;

    my @r1 = eval { "Term::ANSIColorx::ColorNicknames::$f"->(@{ $todo{$key}[1] }) };
    my $e1 = $@; my $e1l = $1 if $e1 =~ m/line (\d+)/;

    my @r2 = eval { "Term::ANSIColor::$f"->(@{ $todo{$key}[0] }) };
    my $e2 = $@; $e2 =~ s/line \d+/line $e1l/ if $e1l;

    ok( "@r1 -" . (0+@r1), "@r2 -" . (0+@r2) );
    ok( $e1, $e2 );
}
