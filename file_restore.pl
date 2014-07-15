#!/usr/bin/perl

# Last ditch attempt for file restoration if you know a string in the deleted file.
#
# Will only get you as far as the byte offsets, the rest you'll have to do yourself
# Used for when grep -ab /dev/sda returns line too long errors
#
# This is the only requirement, and all it does it display a progress bar.
# Debian has this packaged as libterm-progressbar-perl
# If you can't find it, delete this line, the my $progress line and the
# $progress->update line - no real functionality will be lost.

use Term::ProgressBar;

use warnings;
use strict;

my $offset = 0;
my $increment = 10000;
my $output;
# Don't write the output to the same place you're restoring from!
# Mount $file in a read only rescue boot, or even better copy it to a disk image
# on a different drive.
my $file = '/dev/sda2';
my $progress = Term::ProgressBar->new(-s $file);
open my $fh, "<", $file;

while (read($fh, $output, $increment)) {
   print "$offset $output" if $output =~ m#some_important_string_as_a_regex#;
   $offset += $increment;
   $progress->update($offset);
}

close $fh;
