
package App::HI;

use strict;
use Text::Table;
use Term::Size;

our $VERSION = '2.7187';

sub top_matter {
    my $no_extra = shift;

    if( $no_extra ) {
        eval q { use Term::ANSIColorx::AutoFilterFH qw(filtered_handle); 1 }
        or die $@;

    } else {
        eval q { use Term::ANSIColorx::AutoFilterFH qw(colorpackage=Term::ANSIColorx::ColorNicknames filtered_handle); 1 }
        or die $@;
    }

    if( @_ ) {
        eval qq/ use Term::ANSIColor qw(@_); 1 /
        or die $@;
    }
}

sub fire_filter {
    my $truncate = shift;
    my $no_extra = shift;

    top_matter( $no_extra );

    my $newstdout = filtered_handle(\*STDOUT, @ARGV);
    $| = 1; my $oldstdout = select $newstdout; $|=1;
    $newstdout->set_truncate($truncate) if $truncate;

    binmode $newstdout, ':utf8';
    binmode STDIN,      ':utf8';

    while(<STDIN>) {
        print
    }
}

sub list_colors {
    my $truncate = shift;
    my $no_extra = shift;

    top_matter( $no_extra => qw(color colorvalid) );

    my $table;

    my @colors = (
                         qw( black red green yellow blue magenta cyan white ),
        map("bold $_",   qw( black red green yellow blue magenta cyan white )),
        map("bright_$_", qw( black red green yellow blue magenta cyan white )),

        "white on_black", "white on_red", "blue on_green", "black on_yellow",
        "white on_blue", "white on_magenta", "black on_cyan", "black on_white"
    );

    @colors = grep {
        my $valid = colorvalid($_);
        warn "$_ isn't valid" unless $valid;

    $valid} @colors;

    my ($columns, $rows) = Term::Size::chars *STDOUT;

    $columns --;

    my $m = 20;
    UGH_SO_BAD: {
        # XXX: this is so in-efficient it makes my soul hurt
        $table = Text::Table->new;

        my @row;
        for(@colors) {
            push @row, $_;

            unless( @row % $m ) {
                $table->add(map {color($_) . $_ . color("reset")} @row);
                @row = ();
            }
        }

        $table->add(@row) if @row;

        $m -= 2;
        redo UGH_SO_BAD if $table->width > $columns;
    }

    print $table;
}

__END__

=head1 NAME

App::HI - highlight things in a stream of output

=head1 SYNOPSIS

This is just a placeholder for the command line app hi(1).

=head1 SEE ALSO

perl(1), hi(1), L<Term::ANSIColor>, L<Term::ANSIColorx::AutoFilterFH>, L<Term::ANSIColorx::ColorNicknames>
