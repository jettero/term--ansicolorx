
package Term::ANSIColorx::ExtraColors;

use strict;
use warnings;
use base 'Term::ANSIColor';

our $VERSION = '2.71'; # 828183 # version approaches e

our %NICKNAMES = (
    red         => "31",
    blood       => "31",
    umber       => "1;31",
    blue        => "34",
    sky         => "1;34",
    ocean       => "36",
    cyan        => "1;36",
    green       => "32",
    lime        => "1;32",
    orange      => "33",
    brown       => "33",
    yellow      => "1;33",
    magenta     => "35",
    purple      => "35",
    violet      => "1;35",
    boldpurple  => "1;35",
    boldmagenta => "1;35",
    black       => "1;30",
    white       => "1;37",
    dire        => "1;33;41",
);

*EXPORT      = \@Term::ANSIColor::EXPORT;
*EXPORT_OK   = \@Term::ANSIColor::EXPORT_OK;
*EXPORT_TAGS = \%Term::ANSIColor::EXPORT_TAGS;

*AUTOLOAD = \&Term::ANSIColor::AUTOLOAD;

@Term::ANSIColor::attributes{keys %NICKNAMES} = values %NICKNAMES;
{
    my %tmp;
    @{ $Term::ANSIColor::EXPORT_TAGS{constants} } =
        grep {!$tmp{$_}++}
        @{ $Term::ANSIColor::EXPORT_TAGS{constants} },
        map {uc $_} keys %Term::ANSIColor::attributes;

   Exporter::export_ok_tags ('constants');

   #use Data::Dump qw(dump);
   #die dump( $Term::ANSIColor::EXPORT_TAGS{constants} );
}

"true";
