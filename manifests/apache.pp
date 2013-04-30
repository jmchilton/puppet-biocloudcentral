
class biocloudcentral::apache (
) {

  # Local variables needed for templates
  $destination = $biocloudcentral::config::destination
  $biocloudcentral_user = $biocloudcentral::config::user
  $log_dir = $biocloudcentral::config::log_dir

  apache::vhost { 'biocloudcentral vhost':
    port => '80',
    custom_fragment => template('biocloudcentral/vhost.erb'),
    docroot => $destination,
  }

}