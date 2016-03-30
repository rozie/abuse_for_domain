abuse_for_domain
=========

Returns proper abuse contact for given domains. Script read reads string from STDIN,
determines if it's FQDN or IPv4, returns input string, IP address and abuse email.
It relies on DNS queries and abusix.org.

Input
---------
Reads from STDIN, one FQDN or IP address per line.

Output
---------
input string, IP, abuse email. Space separated.

Example
----------
perl abuse_for_domain.pl < file_with_abusing_IPs.txt

Notices
----------
* FQDNs without A record, with no abuse, on failed queries are silently skipped.
* Only first abuse email is returned.

License
----------
GPL v2
