
class biocloudcentral::apache (
  $port     = 80,
  $priority = 10,
) {

  # Local variables needed for templates
  $destination = $biocloudcentral::config::destination
  $biocloudcentral_user = $biocloudcentral::config::user
  $log_dir = $biocloudcentral::config::log_dir

  apache::vhost { 'biocloudcentral':
    port            => '80',
    custom_fragment => template('biocloudcentral/vhost.erb'),
    docroot         => $destination,
    priority        => 10,
  }

}