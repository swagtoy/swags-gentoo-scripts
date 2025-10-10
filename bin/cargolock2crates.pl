#!/usr/bin/env perl
# Licensed under the BSD-3 Clause license. See LICENSE.

# A simple for generating the CRATES variable for ebuilds.
#
# It was made when I had some issues with pycargoebuild. That one does
#   a lot of extra fancy stuff but all this really does is exactly
#   what it says on the tin. If you have issues with pycargoebuilds
#   crate generating ability this may come in handy. It won't be
#   sufficient though, as you'll be responsible for getting at the
#   licenses.

# TODO make this function as a module too

my $cargofile = "Cargo.lock";
open my $fh, $cargofile or die "Couldn't open $cargofile: $!";

my $output = "CRATES=\"\n";

my $curr_name;
while (my $line = <$fh>)
{
	if ($line =~ /name = "(.*?)"/)
	{
		$curr_name = $1;
		next;
	}
	
	if ($line =~ /version = "(.*?)"/)
	{
		my $version = $1;
		
		$output .= "\t" . $curr_name . '@' . "$version\n";
	}
}

$output .= "\"";
print $output . "\n";

close $fh;
