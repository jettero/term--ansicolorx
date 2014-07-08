
package Term::ANSIColorx::AutoFilterFH;

use Carp;
use Symbol;
use Tie::Handle;
use base 'Tie::StdHandle';
use base 'Exporter';

sub import {
    my @__;
    my $color_package = Term::ANSIColorx::ColorNicknames->can("import") ? "Term::ANSIColorx::ColorNicknames" : "Term::ANSIColor";

    for(@_) {
        if( m/\Acolor.?package\s*=\s*(\S+)\z/ ) {
            $color_package = $1

        } else {
            push @__, $_
        }
    }

    eval qq{ use $color_package qw(color colorvalid); 1 }
        or die $@;

    __PACKAGE__->export_to_level(1, @__);
}

use common::sense;

our $VERSION = '2.7188';
our @EXPORT_OK = qw(filtered_handle);

my %pf2t;
my %orig;
my %pats;
my %trun;

my (@icolors, $RESET);

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
                substr $it, $i+1, 0, $RESET . "$icolors[$l]";
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

    @icolors = ("");
    $RESET = color("reset");

    my @pats;
    while( (my ($pat,$color) = splice @patterns, 0, 2) ) {
        croak "\@patterns should contain an even number of items" unless defined $color;

        unless( ref($pat) eq "Regexp" ) {
            $pat = eval {qr($pat)};
            croak "RE \"$_\" doesn't compile well: $@" unless $pat;
        }

        # die unless all the elements of @uc are all caps exports of
        # Term::ANSIColor

        croak "color \"$color\" unknown" unless colorvalid($color);
        $color = color($color);

        my ($l) = grep {$color eq $icolors[$_]} 0 .. $#icolors;

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

__END__

=head1 NAME

Term::ANSIColorx::AutoFilterFH - automatically color-highlight a stream

=head1 SYNOPSIS

    use Term::ANSIColorx::ColorNicknames; # optional
    use Term::ANSIColorx::AutoFilterFH qw(filtered_handle);

    my $filtered_stdout = filtered_handle(\*STDOUT,
        'jettero' => 'bold-blue',
        'nobody'  => 'sky', # same as jettero under ColorNicks, or error
        'root'    => 'red',
    );

    print "This has colors: jettero nobody root\n";

    select $filtered_stdout;
    print "This also has colors. -jettero\n";

    $filtered_stdout->set_truncate(80);
    print "This line is only 80 characters... ", ("." x 120), "\n";

=head1 DESCRIPTION

I wanted a way to inject colors into places that didn't otherwise support it.  I
also wanted to make my L<hi> utility as short as possible -- and it worked.
L<hi> is barely three lines, not including the options.

=head1 C<filter_handle()>

This function returns a tied handle with some magic installed.  You can print to
it and select it.  It has one method you can invoke as well.

=head1 C<set_truncate()>

Use this method to set a characters-per-line limit.  Give it an C<undef> or a
C<0> to disable it again.   Caveat:  The truncator assumes input to C<PRINT()>
is a I<line> and as such, the results will seem incorrect when the printing
non-lines.  For example, this will not work right:

    $truncated_handle->set_truncate(80)
    select $truncated_handle;
    print "neato: ", ("." x 120); # this will gain a newline at char 81
    print "\n"; 

=head1 FAQ

Q: You don't seem to understand Tie::Handle, shouldn't you fix it using my
immense knowledge of perl FH globs?

A: You got that right -- although the module functions correctly -- if you want
to help, let me know, or fork the project on github.

=head1 REPORTING BUGS

You can report bugs either via rt.cpan.org or via the issue tracking system on
github.  I'm likely to notice either fairly quickly.

=head1 AUTHOR

Paul Miller C<< <jettero@cpan.org> >>

=head1 COPYRIGHT

Copyright 2009 Paul Miller -- released under the GPL

=head1 SEE ALSO

perl(1), L<Term::ANSIColor>, L<Tie::Handle>
