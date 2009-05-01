
package Term::ANSIColorx::AutoFilterFH;

use strict;
use warnings;
no warnings 'uninitialized'; # sometimes it's ok to compare undef... jesus

use Carp;
use Symbol;
use Tie::Handle;
use Term::ANSIColorx::ExtraColors qw(:constants);
use base 'Tie::StdHandle';
use base 'Exporter';

our $VERSION = '2.718'; # 2.71828183 # version approaches e

our @EXPORT_OK = qw(filtered_handle);

my %orig;
my %pats;

my @icolors = ("");

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

    print {$orig{$this}} @them;
}

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

        croak "color \"$color\" unkown" unless exists $Term::ANSIColorx::ExtraColors::NICKNAMES{lc $color};

        my $color = eval( uc($color) . "()" ) or die $@;
        my ($l)   = grep {$color eq $icolors[$_]} 0 .. $#icolors;

        unless($l) {
            push @icolors, $color;
            $l = $#icolors;
        }
        
        push @pats, [ $pat => $l ];
    }

    my $pfft = gensym();
    my $it = tie *{$pfft}, __PACKAGE__ or die $!;

    $orig{$it} = $fh;
    $pats{$it} = \@pats;

    $pfft;
}

"true";
