#!/usr/bin/perl -w
use strict;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME      => 'px',
  AUTHOR    => q{Synacor, Inc.},
  VERSION_FROM => 'bin/px',
  ABSTRACT  => "Pipe X-Ray analyzes the pipeline it's in or the pipline for the given pid.",
  ($ExtUtils::MakeMaker::VERSION >= 6.3002 ? ('LICENSE' => 'gpl_3') : ()),
  PL_FILES  => {},
  EXE_FILES => [
    'bin/px',
  ],
  PREREQ_PM => {},
  dist      => {COMPRESS     => 'gzip -9f', SUFFIX => 'gz',},
  clean     => {FILES        => 'px-*, *.spec'},
);
