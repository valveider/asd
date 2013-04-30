# = Class: ntp
#
# Este módulo nos permite configurar con un solo archivo la
# obtencion del horario de diversos equipos sin que sean
# necesariamente de la misma distribucion.
# 
# == Requisitos:
# 
# Una maquina con alguno de estos 4 sistemas operativos:
# 1. Debian
# 2. RedHat
# 3. Ubuntu
# 4. CentOs
# 
# == Parametros:
# 
# $enable: Nos permite activar o desactivar el servicio.
# $ensure: Nos permite instalar, desinstalar, purgar... el servicio 
# 
# == Ejemplo de uso:
# 
# puppet apply -e "class {'ntp': enable => 'true', ensure => 'installed'}"
# 
#  
    class ntp ($enable, $ensure) {
      case $operatingsystem {
        centos, redhat: { 
          $service_name    = 'ntpd'
          $conf_template   = 'ntp.conf.el.erb'
          $default_servers = [ "0.centos.pool.ntp.org",
                               "1.centos.pool.ntp.org",
                               "2.centos.pool.ntp.org", ]
        }
        debian, ubuntu: { 
          $service_name    = 'ntp'
          $conf_template   = 'ntp.conf.debian.erb'
          $default_servers = [ "0.debian.pool.ntp.org iburst",
                               "1.debian.pool.ntp.org iburst",
                               "2.debian.pool.ntp.org iburst",
                               "3.debian.pool.ntp.org iburst", ]
        }
      }
      
      if $servers == undef {
        $servers_real = $default_servers
      }
      else {
        $servers_real = $servers
      }      
      package { 'ntp':
        ensure => installed,
      } 
      service { 'ntp':
        name      => $service_name,
        ensure    => $ensure,
        enable    => $enable,
        subscribe => File['ntp.conf'],
      }
      
      file { 'ntp.conf':
        path    => '/etc/ntp.conf',
        ensure  => file,
        require => Package['ntp'],
        content => template("ntp/${conf_template}"),
      }
    }
