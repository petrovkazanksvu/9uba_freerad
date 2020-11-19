# -*- text -*-
##
## clients.conf -- client configuration directives
##
##	$Id: 76b300d3c55f1c5c052289b76bf28ac3a370bbb2 $

#######################################################################
#
#  Define RADIUS clients (usually a NAS, Access Point, etc.).

#
#  Defines a RADIUS client.
#
#  '127.0.0.1' is another name for 'localhost'.  It is enabled by default,
#  to allow testing of the server after an initial installation.  If you
#  are not going to be permitting RADIUS queries from localhost, we suggest
#  that you delete, or comment out, this entry.
#
#

#
#  Each client has a "short name" that is used to distinguish it from
#  other clients.
#
#  In version 1.x, the string after the word "client" was the IP
#  address of the client.  In 2.0, the IP address is configured via
#  the "ipaddr" or "ipv6addr" fields.  For compatibility, the 1.x
#  format is still accepted.
#
client localhost {
	#  Only *one* of ipaddr, ipv4addr, ipv6addr may be specified for
	#  a client.
	#
	#  ipaddr will accept IPv4 or IPv6 addresses with optional CIDR
	#  notation '/<mask>' to specify ranges.
	#
	#  ipaddr will accept domain names e.g. example.org resolving
	#  them via DNS.
	#
	#  If both A and AAAA records are found, A records will be
	#  used in preference to AAAA.
	ipaddr = 127.0.0.1

	#  Same as ipaddr but allows v4 addresses only. Requires A
	#  record for domain names.
#	ipv4addr = *	# any.  127.0.0.1 == localhost

	#  Same as ipaddr but allows v6 addresses only. Requires AAAA
	#  record for domain names.
#	ipv6addr = ::	# any.  ::1 == localhost

	#
	#  A note on DNS:  We STRONGLY recommend using IP addresses
	#  rather than host names.  Using host names means that the
	#  server will do DNS lookups when it starts, making it
	#  dependent on DNS.  i.e. If anything goes wrong with DNS,
	#  the server won't start!
	#
	#  The server also looks up the IP address from DNS once, and
	#  only once, when it starts.  If the DNS record is later
	#  updated, the server WILL NOT see that update.
	#

	#
	#  The transport protocol.
	#
	#  If unspecified, defaults to "udp", which is the traditional
	#  RADIUS transport.  It may also be "tcp", in which case the
	#  server will accept connections from this client ONLY over TCP.
	#
	proto = *

	#
	#  The shared secret use to "encrypt" and "sign" packets between
	#  the NAS and FreeRADIUS.  You MUST change this secret from the
	#  default, otherwise it's not a secret any more!
	#
	#  The secret can be any string, up to 8k characters in length.
	#
	#  Control codes can be entered vi octal encoding,
	#	e.g. "\101\102" == "AB"
	#  Quotation marks can be entered by escaping them,
	#	e.g. "foo\"bar"
	#
	#  A note on security:  The security of the RADIUS protocol
	#  depends COMPLETELY on this secret!  We recommend using a
	#  shared secret that is composed of:
	#
	#	upper case letters
	#	lower case letters
	#	numbers
	#
	#  And is at LEAST 8 characters long, preferably 16 characters in
	#  length.  The secret MUST be random, and should not be words,
	#  phrase, or anything else that is recognisable.
	#
	#  The default secret below is only for testing, and should
	#  not be used in any real environment.
	#
	secret = testing123

	#
	#  Old-style clients do not send a Message-Authenticator
	#  in an Access-Request.  RFC 5080 suggests that all clients
	#  SHOULD include it in an Access-Request.  The configuration
	#  item below allows the server to require it.  If a client
	#  is required to include a Message-Authenticator and it does
	#  not, then the packet will be silently discarded.
	#
	#  allowed values: yes, no
	require_message_authenticator = no

	#
	#  The short name is used as an alias for the fully qualified
	#  domain name, or the IP address.
	#
	#  It is accepted for compatibility with 1.x, but it is no
	#  longer necessary in >= 2.0
	#
#	shortname = localhost

	#
	# the following three fields are optional, but may be used by
	# checkrad.pl for simultaneous use checks
	#

	#
	# The nas_type tells 'checkrad.pl' which NAS-specific method to
	#  use to query the NAS for simultaneous use.
	#
	#  Permitted NAS types are:
	#
	#	cisco
	#	computone
	#	livingston
	#	juniper
	#	max40xx
	#	multitech
	#	netserver
	#	pathras
	#	patton
	#	portslave
	#	tc
	#	usrhiper
	#	other		# for all other types

	#
	nas_type	 = other	# localhost isn't usually a NAS...

	#
	#  The following two configurations are for future use.
	#  The 'naspasswd' file is currently used to store the NAS
	#  login name and password, which is used by checkrad.pl
	#  when querying the NAS for simultaneous use.
	#
#	login	   = !root
#	password	= someadminpas

	#
	#  As of 2.0, clients can also be tied to a virtual server.
	#  This is done by setting the "virtual_server" configuration
	#  item, as in the example below.
	#
#	virtual_server = home1

	#
	#  A pointer to the "home_server_pool" OR a "home_server"
	#  section that contains the CoA configuration for this
	#  client.  For an example of a coa home server or pool,
	#  see raddb/sites-available/originate-coa
#	coa_server = coa

	#
	#  Response window for proxied packets.  If non-zero,
	#  then the lower of (home, client) response_window
	#  will be used.
	#
	#  i.e. it can be used to lower the response_window
	#  packets from one client to a home server.  It cannot
	#  be used to raise the response_window.
	#
#	response_window = 10.0

	#
	#  Connection limiting for clients using "proto = tcp".
	#
	#  This section is ignored for clients sending UDP traffic
	#
	limit {
		#
		#  Limit the number of simultaneous TCP connections from a client
		#
		#  The default is 16.
		#  Setting this to 0 means "no limit"
		max_connections = 16

		#  The per-socket "max_requests" option does not exist.

		#
		#  The lifetime, in seconds, of a TCP connection.  After
		#  this lifetime, the connection will be closed.
		#
		#  Setting this to 0 means "forever".
		lifetime = 0

		#
		#  The idle timeout, in seconds, of a TCP connection.
		#  If no packets have been received over the connection for
		#  this time, the connection will be closed.
		#
		#  Setting this to 0 means "no timeout".
		#
		#  We STRONGLY RECOMMEND that you set an idle timeout.
		#
		idle_timeout = 30
	}
}

# IPv6 Client
client localhost_ipv6 {
	ipv6addr	= ::1
	secret		= testing123
}

# All IPv6 Site-local clients
#client sitelocal_ipv6 {
#	ipv6addr	= fe80::/16
#	secret		= testing123
#}

#client example.org {
#	ipaddr		= radius.example.org
#	secret		= testing123
#}

#
#  You can now specify one secret for a network of clients.
#  When a client request comes in, the BEST match is chosen.
#  i.e. The entry from the smallest possible network.
#
client private-network-1 {
	ipaddr		= 192.168.160.0/20
	secret		= testing123
}

#client private-network-2 {
#	ipaddr		= 198.51.100.0/24
#	secret		= testing123
#}

#######################################################################
#
#  Per-socket client lists.  The configuration entries are exactly
#  the same as above, but they are nested inside of a section.
#
#  You can have as many per-socket client lists as you have "listen"
#  sections, or you can re-use a list among multiple "listen" sections.
#
#  Un-comment this section, and edit a "listen" section to add:
#  "clients = per_socket_clients".  That IP address/port combination
#  will then accept ONLY the clients listed in this section.
#
#clients per_socket_clients {
#	client socket_client {
#		ipaddr = 192.0.2.4
#		secret = testing123
#	}
#}
#client new {
#ipaddr = 192.168.160.2
#secret = testing123
#}
