
require 5.006001;

use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Term::ANSIColorx',
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
);
