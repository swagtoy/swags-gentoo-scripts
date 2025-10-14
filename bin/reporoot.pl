#!/usr/bin/env perl
# Licensed under the BSD-3 Clause license. See LICENSE.

# Resolves the root of a portage repository from any point.
# 
# If ran in /var/db/repos/gentoo/x11-wm/mutter, it'll resolve to
#   /var/db/repos/gentoo. You can also pass --relative-from-root and
#   you'll get x11-wm/mutter.

use warnings;
use Getopt::Long;
use Cwd;
use File::Basename;
use File::Spec;

my $relative_from_root = 0;
GetOptions('relative-from-root!' => \$relative_from_root,
           'help' => sub { exit if print "Usage: reporoot.pl [--relative-from-root] [PATH]\n" });

my $path_fetch = $ARGV[0] || getcwd;
my($__,$path,$ebuild_maybe) = File::Spec->splitpath($path_fetch);
# Very lazy, but whatever
$path .= $ebuild_maybe unless $ebuild_maybe =~ /.ebuild$/;
$path =~ s|/$||;
my $up_path = $path;

while (1)
{
	last if $up_path eq '/' || !$up_path;
	
	if (-d "$up_path/profiles")
	{
		if ($relative_from_root != 0)
		{
			$path =~ s/$up_path//;
			$path =~ s|^/||;
			last if print $path . "\n";
		}
		last if print $up_path . "\n";
	}
	
	$up_path = dirname $up_path;
}

exit 1 if $up_path eq '/';
