#
class nova::compute::baremetal (
  $db_type = 'sqlite',
  $db_host = undef,
  $nova_bm_db_dbname = '/var/lib/nova/nova.sqlite',
  $nova_bm_db_user = undef,
  $nova_bm_db_password = undef,
) {

  include nova::params

  case $db_type {
    'sqlite':          {
        $sql_connection = "sqlite://${nova_bm_db_dbname}"
    }
    default:            {
        $sql_connection = "${db_type}://${nova_bm_db_user}:${nova_bm_db_password}@${db_host}/${nova_bm_db_dbname}"
    }
  }

  nova_config {
    'DEFAULT/compute_driver':   value => 'nova.virt.baremetal.driver.BareMetalDriver';
    'baremetal/sql_connection': value => $sql_connection;
  }

  package { 'nova-baremetal':
    name   => $::nova::params::baremetal_package_name,
    ensure => present,
  }
}
