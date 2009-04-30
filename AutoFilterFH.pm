
package Term::ANSIColorx::AutoFilterFH;

use strict;

use Carp;
use Symbol;
use Tie::Handle;
use Term::ANSIColorx::ExtraColors qw(:constants);
use base 'Tie::StdHandle';
use base 'Exporter';

our $VERSION = '2.71'; # 828183 # version approaches e

our @EXPORT_OK = qw(filtered_handle);

my %orig;
my %pats;

sub PRINT {
    my $this = shift;
    my @them = @_;

    my @colors;

    for my $p ( @{$pats{$this}} ) {
        for(@them) {
            while( m/($p->[0])/g ) {
                $colors[$_] = $p->[1] for $-[1] .. $+[1]-1;
            }
        }
    }

    use Data::Dump qw(dump);
    die dump(\@colors);

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

        push @pats, [$pat => eval(uc($color)) ];
    }

    my $pfft = gensym();
    my $it = tie *{$pfft}, __PACKAGE__ or die $!;

    $orig{$it} = $fh;
    $pats{$it} = \@pats;

    $pfft;
}

"true";
