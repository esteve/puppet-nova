#
class nova::compute::baremetal (
  $db_type = 'sqlite',
  $db_host = undef,
  $nova_bm_db_dbname = '/var/lib/nova/nova.sqlite',
  $nova_bm_db_user = undef,
  $nova_bm_db_password = undef,
  $tftp_root = '/tftpboot',
  $power_manager = 'nova.virt.baremetal.ipmi.IPMI',
  $driver = 'nova.virt.baremetal.pxe.PXE',
  $instance_type_extra_specs = 'cpu_arch:{i386|x86_64}',
  $enabled = true,
  $ensure_package = 'present',
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
    'baremetal/tftp_root': value => $tftp_root;
    'baremetal/power_manager': value => $power_manager;
    'baremetal/driver': value => $driver;
    'baremetal/instance_type_extra_specs': value => $instance_type_extra_specs;
  }

  nova::generic_service { 'baremetal':
    enabled        => $enabled,
    ensure_package => $ensure_package,
    package_name   => $::nova::params::baremetal_package_name,
    service_name   => $::nova::params::baremetal_service_name,
  }
}
