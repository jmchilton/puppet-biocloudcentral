class biocloudcentral(
  $repository_url = 'git://github.com/chapmanb/biocloudcentral.git',
  $db_name = 'biocloudcentral',
  $db_username = 'biocloudcentral',
  $db_password = '',
  $db_host = '',
  $db_port = '5432',
  $redirect_base = 'https://biocloudcentral.herokuapp.com/',
  $secret_key = 'takj3d3$gv%^ulsdsp_q0-458%&rb7@#utq_%1g+*_9zp@ub09',
) {
  include biocloudcentral::config

  # Specify default path for execs.
  Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }

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
    ensure   => present,
    provider => git,
    source   => $repository_url,
    user     => "$biocloudcentral::config::user",
    require  => User["$biocloudcentral::config::user"],
    force    => true,
  }

  class { "python": 
    dev        => true,
    virtualenv => true,
  }

  python::virtualenv { "$biocloudcentral::config::destination/venv":
    systempkgs   => false,
    requirements => "$biocloudcentral::config::destination/requirements.txt",
    require      => Vcsrepo["$biocloudcentral::config::destination"],
  }

  file { "$biocloudcentral::config::destination/biocloudcentral/settings_local.py":
    content => template("biocloudcentral/settings_local.py.erb"),
    require => Vcsrepo["$biocloudcentral::config::destination"],
    owner   => "$biocloudcentral::config::user",    
  }

  exec { "biocloudcentral_syncdb":
    command => "/bin/bash -c '. venv/bin/activate; python biocloudcentral/manage.py syncdb; python biocloudcentral/manage.py migrate biocloudcentral'",
    cwd     => "$biocloudcentral::config::destination",
    user    => "$biocloudcentral::config::user",
    require => [ File["$biocloudcentral::config::destination/biocloudcentral/settings_local.py"],
                 Python::Virtualenv["$biocloudcentral::config::destination/venv"],
               ],
  }

}
