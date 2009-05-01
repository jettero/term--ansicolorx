
require 5.006001;

use strict;
use ExtUtils::MakeMaker;

my $install_hi;
if( $ENV{HOSTNAME} eq "corky" and -f ".st" ) {
    $install_hi = "duh";

} else {
    $install_hi = prompt("install the STDOUT pipe highlighter \"hi\"?", "n");
}

WriteMakefile(
    NAME         => 'Term::ANSIColorx::ExtraColors',
    VERSION_FROM => 'ExtraColors.pm',
    PREREQ_PM    => { 
        'Term::ANSIColor' => 0,
    },

    ($ExtUtils::MakeMaker::VERSION ge '6.48'? 
        (MIN_PERL_VERSION => 5.006001,
            META_MERGE => {
                resources=> {
                    repository => 'http://github.com/jettero/term--ansicolorx',
                },
            },

        LICENSE	=> 'LGPL',
    ) : ()),

    ( $install_hi =~ m/n/i ? () : EXE_FILES => [ 'hi' ] ),

    clean => { FILES => 'dist TEST' },
);
