
package App::HI;

use strict;
use Text::Table;

our $VERSION = '2.7187';

sub fire_filter {
    my $truncate = shift;
    my $no_extra = shift;

    unless( $no_extra ) {
        eval q { use Term::ANSIColorx::ColorNicknames; 1 }
        or die $@;
    }

    eval q { use Term::ANSIColorx::AutoFilterFH qw(filtered_handle); 1 }
    or die $@;

    my $newstdout = filtered_handle(\*STDOUT, @ARGV);
    $| = 1; my $oldstdout = select $newstdout; $|=1;
    $newstdout->set_truncate($truncate) if $truncate;

    binmode $newstdout, ':utf8';
    binmode STDIN,      ':utf8';

    while(<STDIN>) {
        print
    }
}

__END__

=head1 NAME

App::HI - highlight things in a stream of output

=head1 SYNOPSIS

This is just a placeholder for the command line app hi(1).

=head1 SEE ALSO

perl(1), hi(1), L<Term::ANSIColor>, L<Term::ANSIColorx::AutoFilterFH>, L<Term::ANSIColorx::ColorNicknames>
