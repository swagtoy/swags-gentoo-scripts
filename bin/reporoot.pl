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

my $relative_from_root = 0;
GetOptions('relative-from-root!' => \$relative_from_root,
           'help' => sub { exit if print "Usage: reporoot.pl [--relative-from-root] [PATH]\n" });

my $decr = 0; # amount we've went up.

my $path = $ARGV[0] || getcwd;
my $up_path = $path;

while (1)
{
	last if $up_path eq '/';
	
	if (-d "$up_path/metadata")
	{
		if ($relative_from_root != 0)
		{
			#$up_path = dirname $up_path;
			$path =~ s/$up_path//;
			$path =~ s|^/||;
			last if print $path . "\n";
		}
		last if print $up_path . "\n";
	}
	
	++$decr;
	$up_path = dirname $up_path;
}

exit 1 if $up_path eq '/';

#print dirname(dirname(dirname($path)));
