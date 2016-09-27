#!/usr/bin/perl

# Script read reads FQDN, returns FQDN, IP and abuse email (using DNS query and abusix.org).
# Input: reads from STDIN, one FQDN per line
# Output: FQDN, IP, abuse email, space separated
#
# Required modules: Net::DNS (libnet-dns-perl package on Debian/Ubuntu)
# Author: Pawe� 'R��a' R��a�ski rozie[at]poczta(dot)onet(dot)pl
# License: GPL v2.
#
# Notices:
# * FQDNs without A record, with no abuse, on failed queries are silently skipped right now
# * only first abuse email is returned

use warnings;
use strict;
use Net::DNS;

# read everything from STDIN
while (<>) {
    chomp;
    if (/^\d+\.\d+\.\d+\.\d+/) {    # IPv4 address
        my $ip    = $_;
        my $abuse = get_abuse_email($ip);    # get abuse email
        if ( defined $abuse ) {              # only if got abuse email
            print "$ip $ip $abuse\n";
        }
    }
    elsif (/^(\S+)/) {    # get only non-white characters at line start
        my $fqdn = $1;
        my $ip_a = "";

        my $res   = Net::DNS::Resolver->new;
        my $reply = $res->search($fqdn);

        if ($reply) {     # only if got DNS reply
            foreach my $rr ( $reply->answer ) {
                next unless $rr->type eq "A";
                $ip_a = $rr->address;
            }
            my $abuse = get_abuse_email($ip_a);    # get abuse email
            if ( defined $abuse ) {                # only if got abuse email
                print "$fqdn $ip_a $abuse\n";
            }
        }
    }
}

# function which returns proper abuse for given IP
sub get_abuse_email {
    my $reply = undef;    # undef means error and this is default
    my $ip    = $_[0];    # get IP (v4 only) as an argument
    if ( $ip =~ /^\d+\.\d+\.\d+\.\d+$/ ) {    # rough check if IP is valid
        my $reverse = join( ".", reverse( split /\./, $ip ) );
        my $query   = $reverse . ".abuse-contacts.abusix.org\n"; # prepare query
        my $result  = `host -t TXT $query`;
        if ( $result =~ /\"(.*?)\"/ ) {
            $reply = $1;
        }
        return $reply;
    }
    else {
        return $reply;
    }
}
