
package Term::ANSIColorx::AutoFilterFH;

use strict;
use warnings;
no warnings 'uninitialized'; # sometimes it's ok to compare undef... jesus

use Carp;
use Symbol;
use Tie::Handle;
use Term::ANSIColor qw(:constants);
use base 'Tie::StdHandle';
use base 'Exporter';

our $VERSION = '2.7182'; # 2.71828183 # version approaches e

our @EXPORT_OK = qw(filtered_handle);

my %pf2t;
my %orig;
my %pats;
my %trun;

my @icolors = ("");

# DESTROY {{{
sub DESTROY {
    my $this = shift;

    for my $pfft (keys %pf2t) {
        if( $pf2t{$pfft} == $this ) {
            delete $pf2t{$pfft};
            last;
        }
    }

    delete $orig{$this};
    delete $pats{$this};
    delete $trun{$this};
}
# }}}
# set_truncate {{{
sub set_truncate {
    my $pfft = shift;
    my $that = int shift;
    my $this = $pf2t{$pfft};

    return delete $trun{$this} unless $that > 0;

    $trun{$this} = $that;
}
# }}}
# PRINT {{{
sub PRINT {
    my $this = shift;
    my @them = @_;

    for my $it (@them) {
        my @colors;

        for my $p ( @{$pats{$this}} ) {
            while( $it =~ m/($p->[0])/g ) {
                $colors[$_] = $p->[1] for $-[1] .. $+[1]-1;
            }
        }

        my $l = 0;
        for my $i ( reverse 0 .. $#colors ) {
            if( (my $n = $colors[$i]) != $l ) {
                substr $it, $i+1, 0, RESET . "$icolors[$l]";
                $l = $n;
            }
        }
        substr $it, 0, 0, $icolors[$colors[0]] if $colors[0];
    }

    if( my $trun = $trun{$this} ) {
        # TODO This assumes all PRINT()s are *lines*, and they're clearly not.

        local $";
        my $line = "@them";
        (substr $line, $trun) = "\n" if length $line > $trun+1;
        print {$orig{$this}} $line;

        return;
    }

    print {$orig{$this}} @them;
}
# }}}
# filtered_handle {{{
sub filtered_handle {
    my ($fh, @patterns) = @_;
    croak "filtered_handle(globref, \@patterns)" unless ref($fh) eq "GLOB";

    my @pats;
    while( (my ($pat,$color) = splice @patterns, 0, 2) ) {
        croak "\@patterns should contain an even number of items" unless defined $color;

        unless( ref($pat) eq "Regexp" ) {
            $pat = eval {qr($pat)};
            croak "RE \"$_\" doesn't compile well: $@" unless $pat;
        }

        my @uc = split m/[,\s-]+/, uc $color;
        my $eval_str = join(" . ", map("$_()", @uc));

        # die unless all the elements of @uc are found in
        # @Term::ANSIColor::EXPORT_OK
        my $color_c  = grep { my $tac=$_; grep {$tac eq $_} @uc } @Term::ANSIColor::EXPORT_OK;
        croak "color \"$color\" (understood as $eval_str) unknown" unless @uc == $color_c;

        my $color = eval $eval_str or die $@;
        my ($l)   = grep {$color eq $icolors[$_]} 0 .. $#icolors;

        unless($l) {
            push @icolors, $color;
            $l = $#icolors;
        }

        push @pats, [ $pat => $l ];
    }

    # NOTE: This is called pfft because I'd like to get rid of it.
    # it doesn't seem like I should need it and it irritates me.
    my $pfft = bless gensym();
    my $this = tie *{$pfft}, __PACKAGE__ or die $!;

    $pf2t{$pfft} = $this;
    $orig{$this} = $fh;
    $pats{$this} = \@pats;

    $pfft;
}
# }}}

"true";
