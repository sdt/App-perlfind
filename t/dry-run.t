#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use App::perlfind;
use Capture::Tiny qw(capture);
test_find(
    [qw(-c foobar --dry-run xor)],
    "foobar perlop\n",
    'foobar: xor -> perlop'
);
my %expect = (
    'xor'                    => 'perlop',
    'foreach'                => 'perlsyn',
    'isa'                    => 'perlobj',
    'TIEARRAY'               => 'perltie',
    'AUTOLOAD'               => 'perlsub',
    'INPUT_RECORD_SEPARATOR' => 'perlvar',
    '$^F'                    => 'perlvar',
    'PERL5OPT'               => 'perlrun',
    ':mmap'                  => 'PerlIO',
    '__WARN__'               => 'perlvar',
    '__PACKAGE__'            => 'perldata',
    'head4'                  => 'perlpod',
);
while (my ($query, $result) = each %expect) {
    test_find([ '-n', $query ], "perldoc $result\n", "$query -> $result");
}
done_testing;

sub test_find {
    my ($args, $expect, $name) = @_;
    $App::perlfind::executed = 0;
    @ARGV                     = @$args;
    my ($stdout, $stderr) = capture {
        App::perlfind->run;
    };
    subtest join(' ' => @$args) => sub {
        is $stdout, '', 'STDOUT empty';
        is $stderr, $expect, $name;
        done_testing;
    };
}
