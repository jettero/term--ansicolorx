
package Term::ANSIColorx::AutoFilterFH;

use strict;
use warnings;

use Carp;
use Symbol;
use Tie::Handle;
use Term::ANSIColorx::ExtraColors;
use base 'Tie::StdHandle';
use base 'Exporter';

our $VERSION = '2.71'; # 828183 # version approaches e

our @EXPORT_OK = qw(filtered_handle);

my %orig;
my %pats;

sub PRINT {
    my $this = shift;
    my @them = @_;
    my @pats = @{ $pats{$this} };

    for my $item (@them) {
        $item =~ s/\e\[[\d;]+m//g
    }

    print {$orig{$this}} @them;
}

sub filtered_handle {
    my ($fh, @patterns) = @_;
    croak "filtered_handle(globref, hashref)" unless ref($fh) eq "GLOB" and ref($patterns) eq "HASH";

    my @pats;
    while( (my ($pat,$color) = splice @patterns, 0, 2) and @a==2 ) {
        unless( ref($pat) eq "Regexp" ) {
            $pat = eval {qr($v)};
            croak "RE \"$_\" doesn't compile well: $@" unless $pat;
        }

        croak "color \"$color\" unkown" unless exists $Term::ANSIColorx::ExtraColors::NICKNAMES{lc $color};

        push @pats, [$pat,$color];
    }

    my $pfft = gensym();
    my $it = tie *{$pfft}, __PACKAGE__ or die $!;

    $orig{$it} = $fh;
    $pats{$it} = \@pats;

    $pfft;
}
