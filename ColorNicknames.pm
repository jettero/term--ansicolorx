
package Term::ANSIColorx::ColorNicknames;

use strict;
use warnings;
use Term::ANSIColor;

our $VERSION = '2.71828'; # 2.71828183 # version approaches e
our $DISABLE_BLACK;

our %NICKNAMES = (
    blood       => "31",
    umber       => "1;31",
    sky         => "1;34",
    ocean       => "36",
    lightblue   => "36",
    cyan        => "1;36",
    lime        => "1;32",
    orange      => "33",
    brown       => "33",
    yellow      => "1;33",
    purple      => "35",
    violet      => "1;35",

    ( ($ENV{DISABLE_BLACK} or $DISABLE_BLACK) ? () : (black => "1;30") ),

    grey        => "37",
    gray        => "37",
    white       => "1;37",
    dire        => "1;33;41",
    todo        => "0;30;43",
);

@Term::ANSIColor::ATTRIBUTES{keys %NICKNAMES} = values %NICKNAMES;
{
    my %tmp = ();
    @tmp{ @Term::ANSIColor::COLORLIST, map {uc $_} keys %NICKNAMES } = ();
    @Term::ANSIColor::COLORLIST = keys %tmp;

    for my $key (qw(constants pushpop)) {
        %tmp = ();
        @tmp{ @{$Term::ANSIColor::EXPORT_TAGS{$key}}, @Term::ANSIColor::COLORLIST } = ();
        $Term::ANSIColor::EXPORT_TAGS{$key} = [keys %tmp];
    }

    local *EXPORT      = \@Term::ANSIColor::EXPORT;
    local *EXPORT_OK   = \@Term::ANSIColor::EXPORT_OK;
    local *EXPORT_TAGS = \%Term::ANSIColor::EXPORT_TAGS;

    Exporter::export_ok_tags ('pushpop');
}

"true";
