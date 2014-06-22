
use strict;
no strict 'refs';

use Test;
use Term::ANSIColorx::ColorNicknames;

my %todo = (
    colored_1 => [  [["bold","blue"],"this","that"] => [['sky'],'this','that']  ],
    colored_2 => [  ["this that", "bold", "blue"]   => ["this that", "sky"]     ],

    color_1 => [ ['blue'], ['blue'] ],
    color_2 => [ ['bold blue'], ['sky'] ],
    color_3 => [ ['bold blue on_white'], ['bold-sky-on-white'] ],

    uncolor    => [ ["\e[1;34m"], ["\e[1;34m"] ],
    colorstrip => [ ["\e[1;34m"], ["\e[1;34m"] ],

    colorvalid => [ ["blue"], ["sky"] ],

    _blah_just_checking => [ [],[] ],
);

plan tests => 2 * (keys %todo);

for my $key (keys %todo) {
    my $f = $key; $f =~ s/_\d+$//;

    my @r1 = eval { "Term::ANSIColorx::ColorNicknames::$f"->(@{ $todo{$key}[1] }) };
    my $e1 = lc($1) if $@ =~ m/(.+Term::ANSIColor)/;

    my @r2 = eval { "Term::ANSIColor::$f"->(@{ $todo{$key}[0] }) };
    my $e2 = lc($1) if $@ =~ /(.+Term::ANSIColor)/;

    ok( "@r1 -" . (0+@r1), "@r2 -" . (0+@r2) );
    ok( $e1, $e2 );
}
