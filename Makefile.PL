use strict;
use warnings;
use ExtUtils::MakeMaker 6.30;
my $from = 'lib/App/perlfind.pm';
WriteMakefile(
    ABSTRACT_FROM      => $from,
    "AUTHOR"           => 'Marcel Gruenauer <marcel@cpan.org>',
    "BUILD_REQUIRES"   => { 'Test::More' => '0.94' },
    CONFIGURE_REQUIRES => { 'ExtUtils::MakeMaker' => '6.58' },
    LICENSE            => 'perl',
    NAME               => 'App-perlfind',
    EXE_FILES          => [qw(bin/perlfind bin/perlzonji)],
    PREREQ_PM          => {
        'Class::Trigger'    => '0',
        'Module::Pluggable' => '0',
        'Pod::Cpandoc'      => '0',
        'Pod::Functions'    => '0',
        'Test::Differences' => '0',
        'parent'            => '0',
    },
    VERSION_FROM => $from,
    test         => { TESTS => 't/*.t' }
);
