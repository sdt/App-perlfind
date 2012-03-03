use strict;
use warnings;
use ExtUtils::MakeMaker 6.30;
my $from = 'lib/App/perlfind.pm';
WriteMakefile(
    ABSTRACT_FROM    => $from,
    "AUTHOR"         => 'Marcel Gruenauer <marcel@cpan.org>',
    "BUILD_REQUIRES" => {
        'Capture::Tiny' => 0,
        'Carp'          => 0,
        'English'       => 0,
        'File::Find'    => 0,
        'File::Temp'    => 0,
        'Scalar::Util'  => 0,
        'Test::More'    => '0.94'
    },
    CONFIGURE_REQUIRES => { 'ExtUtils::MakeMaker' => '6.58' },
    LICENSE            => 'perl',
    NAME               => 'App-perlfind',
    EXE_FILES          => [qw(bin/perlfind bin/perlzonji)],
    PREREQ_PM          => {
        'Class::Trigger'    => '0',
        'Getopt::Long'      => '0',
        'Module::Pluggable' => '0',
        'Pod::Usage'        => '0',
        'Time::HiRes'       => '0',
        'autodie'           => '0',
        'strict'            => '0',
        'warnings'          => '0',
    },
    VERSION_FROM => $from,
    test         => { TESTS => 't/*.t' }
);
