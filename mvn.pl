#!/usr/bin/perl -w

use LWP::Simple;
my $url = 'http://maven.aliyun.com/nexus/content/groups/public/';
&download($url);

sub download {
	my $html = get($_[0]);
	while ($html && $html =~ m/<a href=\"(.*)\"/g) {
		$href = $1;
		if ($href =~ /^(http)[^';]+\/$/) {
			&download($href);
		} 
		elsif ($href =~ /.*\.(xml|jar|aar|ear|md5|sha1|pom|zip|gz)$/) {
			if ($href =~ /$url(.*)\/[^\/]+/) {
				$dir = $1;
				print "got $href";
				system "mkdir -p $dir";
				$ret = system "wget -N -U \"Mozilla/5.0\" -P \"$dir\" $href >/tmp/wget.log 2>&1";
				print "\t$ret\n";
			} else {
				print "err $href\n";
			}
		} else {
		   	print "ignore $href\n";
		}
	}
}
