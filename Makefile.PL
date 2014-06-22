
require 5.010;

use strict;
use ExtUtils::MakeMaker;

my $install_hi = prompt("install the STDOUT pipe highlighter \"hi\"?", "y");

WriteMakefile(
    NAME         => 'Term::ANSIColorx::ColorNicknames',
    VERSION_FROM => 'lib/Term/ANSIColorx/ColorNicknames.pm',
    j
    PREREQ_PM    => { 
        'Term::ANSIColor' => 4.0,
        'Term::Size'      => 0,
        'Text::Table'     => 0,
    },

    META_MERGE => {
        resources => {
            repository => {
                type => 'git',
                url  => 'git@github.com:jettero/term--ansicolorx.git',
                web  => 'https://github.com/jettero/term--ansicolorx',
            }
        },
    },

    TEST_REQUIRES => {
        'IPC::Run' => 0,
    },

    LICENSE	=> 'GPL',

    ( $install_hi =~ m/n/i ? () : (EXE_FILES=>['bin/hi']) ),

    clean => { FILES => 'dist TEST' },
);
