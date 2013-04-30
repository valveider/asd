class motd ($conf = "1") {

	case $hostname {
	/1$/ : { $equipo = '1'}
	/2$/ : { $equipo = '2'}
	}
	if $conf > "2" {
	notify {'error':
		message => 'Configuracion no encontrada',
		}
	}
	else {
		file { 'motd':
			path => '/etc/motd/',
			ensure => file,
			content => template("motd/motd.erb"),
	}
      }
}
