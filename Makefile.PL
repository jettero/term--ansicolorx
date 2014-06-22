
require 5.006001;

use strict;
use ExtUtils::MakeMaker;

my $install_hi = prompt("install the STDOUT pipe highlighter \"hi\"?", "y");

WriteMakefile(
    NAME         => 'Term::ANSIColorx::ColorNicknames',
    VERSION_FROM => 'lib/Term/ANSIColorx/ColorNicknames.pm',
    PREREQ_PM    => { 
        'Term::ANSIColor' => 4.0,
        'Text::Table'     => 0,
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

    ( $install_hi =~ m/n/i ? () : (EXE_FILES=>['bin/hi']) ),

    clean => { FILES => 'dist TEST' },
);
