package Dist::Zilla::Plugin::InsertExample;

use strict;
use warnings;
use v5.10;
use Moose;

# ABSTRACT: Insert example into your POD from a file
our $VERSION = '0.02'; # VERSION


with 'Dist::Zilla::Role::FileMunger';
with 'Dist::Zilla::Role::FileFinderUser' => {
  default_finders => [ qw( :InstallModules :ExecFiles ) ],
};

sub munge_files
{
  my($self) = @_;
  $self->munge_file($_) for @{ $self->found_files };
}

sub munge_file
{
  my($self, $file) = @_;

  my $content = $file->content;
  if($content =~ s{^#\s*EXAMPLE:\s*(.*)\s*$}{$self->_slurp_example($1)."\n"}meg)
  {
    $self->log([ 'adding examples in %s', $file->name]);
    $file->content($content);
  }
}

sub _slurp_example
{
  my($self, $filename) = @_;
  my $file = $self->zilla->root->file($filename);
  unless(-r $file)
  {
    $self->log_fatal("no such example file $filename");
  }
  join "\n", map { " $_" } split /\n\r?/, $file->slurp;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

Dist::Zilla::Plugin::InsertExample - Insert example into your POD from a file

=head1 VERSION

version 0.02

=head1 SYNOPSIS

In your dist.ini:

 [InsertExample]

In your POD:

 =head1 EXAMPLE
 
 Here is an exaple that writes hello world to the terminal:
 
 # EXAMPLE: example/hello.pl

File in your dist named example/hello.pl

 #!/usr/bin/perl
 say 'hello world';

=head1 DESCRIPTION

This plugin takes examples included in your distribution and
inserts them in your POD where you have an EXAMPLE directive.
This allows you to keep a version in the distribution which
can be run by you and your users, as well as making it
available in your POD documentation, without the need for 
updating example scripts in multiple places.

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
