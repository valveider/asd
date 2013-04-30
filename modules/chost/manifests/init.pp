# = Class chost
# 
# == Descripcion:
# Permite cambiar el nombre de los equipos.
# 
# == Variables: 
# * host: Recogido automaticamente del hostname del host cliente
# * name: Necesario especificarlo en el site.pp. Indicara el nuevo valor del archivo /etc/hostname
# 
# == Acciones:
# 1. exec "hostname": Aun que parezca una estupidez (se vera mas adelante), si no se hace no se aplican los cambios al final.
# 2. file "hostname": Cambia el nombre del host de forma permanente cambiando el valor del archivo /etc/hostname.
# 3. exec "reboot": Reinicia el equipo para aplicar definitivamente los cambios al momento
# 
# nota: Como bien indique en la primera accion, si no la
# realizamos, aun que reiniciemos el equipo, el valor del archivo
# /etc/hostname no se cambia correctamente (por que? ni puta idea)
# 
class chost ($name) {
    case $hostname {
        /1$/ : {$host = '1'}
        /2$/ : {$host = '2'}
    }
    exec { "hostname":
        command => "hostname ${name}-${host}",
        path => "/bin",
    }
    file { "hostname":
        path => "/etc/hostname",
        ensure => file,
        content => "${name}-${host}",
	before => Exec["reboot"],
    }
     exec { "reboot":
	command => "reboot",
	path => "/sbin",
	require => File["hostname"],
	}
}
