    class ntp2 {
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
        ensure    => running,
        enable    => true,
        subscribe => File['ntp.conf'],
      }
      
      file { 'ntp.conf':
        path    => '/etc/ntp.conf',
        ensure  => file,
        require => Package['ntp'],
        content => template("ntp2/${conf_template}"),
      }
    }
