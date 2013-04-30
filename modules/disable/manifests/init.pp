class disable {
$servicios = ["p-memcached", "p-httpd", "p-activemq", "p-dashboard-workers"]

	service { $servicios:
		ensure => stopped,
		enable => false,
		hasstatus => true,
	}

	service {'p-puppet':
		ensure => stopped,
		enable => false,
		hasstatus => true,
	}

Service['p-puppet'] -> Service['p-activemq']


$cronfiles = ["/etc/cron.d/default-add-all-nodes", "/etc/cron.hourly/puppet_baselines.sh"]

	file {$cronfiles:
		ensure => absent,
	}

$network = "NETWORKING=yes
NETWORKING_IPV6=yes
HOSTNAME=clienthost.tegnix.com
"

	file{'network':
		ensure => file,
		path => '/etc/sysconfig/network',
		content => $network,
		
	}

	service {'network':
		ensure => running,
		enable => true,
		hasstatus => true,
		subscribe => File['network']
	}

	if $::hostname != "clienthost.tegnix.com" {
		exec {'set hostname':
			command => "/bin/hostname clienthost.tegnix.com",
			require => File['network'],
			before => Service['network'],
		}
	}

	file {'puppet.conf':
		path    => '/etc/puppet/puppet.conf',
		ensure  => file,
		content => template('disable/puppet.conf.erb'),
		require => Service['p-puppet'],
	}

	file {'ssldir':
		path => '/etc/puppet/ssl',
		ensure => directory,
		purge => true,
		recurse => true,
		force => true,
	}
}
