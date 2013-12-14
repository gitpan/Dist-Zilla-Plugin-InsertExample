use strict;
use warnings;
use Test::More 0.88;
use Test::DZil;

# basing this on the [ModuleBuildDatabase] test for now
plan tests => 1;

my $tzil = Builder->from_config(
  { dist_root => 'corpus/DZT' },
  { 
    add_files => { 
      'source/dist.ini' => simple_ini(
        {},
        'GatherDir',
        [ 'InsertExample' => {} ],
      )
    }
  }
);

$tzil->build;

my($pm) = grep { $_->name eq 'lib/DZT.pm' } @{ $tzil->files };
ok $pm->content =~ m{^ say 'hello world';$}m, "module contains example file";
