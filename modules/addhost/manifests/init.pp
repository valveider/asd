class addhost ($dhost, $ip, $alias = undef) {
	host { $dhost:
		ip => $ip,
		host_aliases => $alias,
	}
}
