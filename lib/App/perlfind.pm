package App::perlfind;
use 5.008;
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use Class::Trigger;
use Module::Pluggable require => 1;
__PACKAGE__->plugins;    # 'require' them
our $VERSION = '2.01';

sub run {
    our %opt = ('perldoc-command' => 'perldoc');
    GetOptions(\%opt, qw(help|h|? man|m perldoc-command|c:s debug dry-run|n))
      or pod2usage(2);
    if ($opt{help}) {
        pod2usage(
            -exitstatus => 0,
            -input      => __FILE__,
        );
    }
    if ($opt{man}) {
        pod2usage(
            -exitstatus => 0,
            -input      => __FILE__,
            -verbose    => 2
        );
    }
    my $word    = shift @ARGV;
    my $matches = find_matches($word);
    if (@$matches) {
        if (@$matches > 1) {
            warn sprintf "%s matches for [%s], using first (%s):\n",
              scalar(@$matches), $word, $matches->[0];
            warn "    $_\n" for @$matches;
        }
        execute($opt{'perldoc-command'}, $matches->[0]);
    }

    # fallback
    warn "assuming that [$word] is a built-in function\n" if $opt{debug};
    execute($opt{'perldoc-command'}, qw(-f), $word);
}

sub find_matches {
    my $word = shift;
    my @matches;
    __PACKAGE__->call_trigger('matches.add', $word, \@matches);
    return \@matches;
}

sub execute {
    our %opt;
    if ($opt{'dry-run'}) {

        # under --dry-run, don't pretend to execute more than once
        our $executed;
        return if $executed++;
        warn "@_\n";
    } else {
        warn "@_\n" if $opt{debug};
        exec @_;
    }
}
1;
__END__

=pod

=head1 NAME

App::perlfind - A more knowledgeable perldoc

=head1 SYNOPSIS

    # perlfind UNIVERSAL::isa
    # (runs `perldoc perlobj`)

=head1 DESCRIPTION

C<perlfind> is like C<perldoc> except it knows about more things. Try these:

    perlfind xor
    perlfind foreach
    perlfind isa
    perlfind AUTOLOAD
    perlfind TIEARRAY
    perlfind INPUT_RECORD_SEPARATOR
    perlfind '$^F'
    perlfind '\Q'
    perlfind PERL5OPT
    perlfind :mmap
    perlfind __WARN__
    perlfind __PACKAGE__
    perlfind head4
    perlfind UNITCHECK

For efficiency, C<alias pod=perlfind>.

=head1 FUNCTIONS

=head2 run

The main function, which is called by the C<perlfind> program.

=head2 try_module

Takes as argument the name of a module, tries to load that module and
executes the formatter, giving that module as an argument. If loading
the module fails, this subroutine does nothing.

=head2 execute

Executes the given command using C<exec()>. In debug mode, it also
prints the command before executing it.

=head2 find_matches

Takes a word and returns the matches for that word. It's in a separate
function to separate logic from presentation so other programs can use
this module as well.

=head1 OPTIONS

Options can be shortened according to L<Getopt::Long/"Case and
abbreviations">.

=over

=item C<--perldoc-command>, C<-c>

Specifies the POD formatter/pager to delegate to. Default is
C<perldoc> C<annopod> from L<AnnoCPAN::Perldoc> is a better
alternative.

=item C<--debug>

Prints the whole command before executing it.

=item C<--dry-run>, C<-n>

Just print the command that would be executed; don't actually execute
it.

=item C<--help>, C<-h>, C<-?>

Prints a brief help message and exits.

=item C<--man>, C<-m>

Prints the manual page and exits.

=back

=head1 AUTHORS

The following persons are the authors of all the files provided in
this distribution unless explicitly noted otherwise.

Marcel Gruenauer <marcel@cpan.org>, L<http://perlservices.at>

Lars Dieckow <daxim@cpan.org>

Leo Lapworth <LLAP@cuckoo.org>

=head1 COPYRIGHT AND LICENSE

The following copyright notice applies to all the files provided in
this distribution, including binary files, unless explicitly noted
otherwise.

This software is copyright (c) 2011 by Marcel Gruenauer.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
