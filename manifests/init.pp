class biocloudcentral(
  $repository_url = 'https://github.com/jmchilton/biocloudcentral',
  $db_name = 'biocloudcentral',
  $db_username = 'biocloudcentral',
  $db_password = '',
  $db_host = '',
  $db_port = '5432',
) {
  include biocloudcentral::config

  user { "$biocloudcentral::config::user":
    ensure => present,
    home => "$biocloudcentral::config::home",
    shell => "/bin/bash",
  }
 
  file { "$biocloudcentral::config::home":
    ensure => directory,
    owner => "$biocloudcentral::config::user",
    require => User["$biocloudcentral::config::user"],
  }

  package { "libpq-dev":
    ensure => "present",
  }

  vcsrepo { "$biocloudcentral::config::destination":
    ensure => present,
    provider => git,
    source => $repository_url,
    owner => "$biocloudcentral::config::user",
    require => User["$biocloudcentral::config::user"]
  }

  exec { 'biocloud_virtualenv':
    command => "/bin/bash -c 'virtualenv --no-site-packages .; source bin/activate; pip install -r requirements.txt'",
    creates => "$biocloudcentral::config::destination/bin",
    require => [Vcsrepo["$biocloudcentral::config::destination"], Package["libpq-dev"],],
    user => "$biocloudcentral::config::user",
  }

  file { "$biocloudcentral::config::destination/biocloudcentral/settings_local.py":
    content => template("biocloudcentral/settings_local.py.erb"),
    require => Vcsrepo["$biocloudcentral::config::destination"],
    owner => "$biocloudcentral::config::user",    
  }

  exec { "biocloudcentral_syncdb":
    command => "/bin/bash -c 'source bin/activate; python biocloudcentral/manage.py syncdb; python biocloudcentral/manage.py migrate biocloudcentral'",
    cwd => "$biocloudcentral::config::destination",
    user => "$biocloudcentral::config::user",
    require => File["$biocloudcentral::config::destination/biocloudcentral/settings_local.py"]
  }

  file { "$biocloudcentral::config::log_dir":
    ensure => directory,
    owner => "$biocloudcentral::config::user",
    mode => 770,
  }

  #apache2::site { "biocloudcentral":
  #  sitedomain => "biocloudcentral",
  #  vhosttemplate => "biocloudcentral/vhost.erb",
  #  confname => "biocloudcentral",
  #  require => [ Apache2::Module["ssl"], 
  #               Package["libapache2-mod-wsgi"],
  #             ],
  #}

}
