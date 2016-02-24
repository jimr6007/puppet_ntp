# ensure ntp is properly configured and running
# class params pulled in via hiera

class ntp ($_ntp_servers = ['ntp1.nym1.placeiq.net']) {

  package { 'ntp':
    ensure => installed,
  }

  service { 'ntpdate':
    enable => false,
  }

  service { 'ntpd':
    ensure => running,
    enable => true,
  }

  file { '/etc/ntp.conf':
    ensure  => file,
    require => Package['ntp'],
    content => template('ntp/ntp.conf.erb'),
    notify  => Service['ntpd'],
  }

  file { '/etc/sysconfig/ntpd':
    ensure  => file,
    require => Package['ntp'],
    source  => 'puppet:///modules/ntp/ntpd',
    notify  => Service['ntpd'],
  }

  file { '/etc/sysconfig/clock':
    ensure => file,
    source => 'puppet:///modules/ntp/clock',
  }

  file { '/etc/localtime':
    ensure => link,
    target => '/usr/share/zoneinfo/UTC',
  }

}
