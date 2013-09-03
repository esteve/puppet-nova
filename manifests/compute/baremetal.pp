#
class nova::compute::baremetal (
) {

  include nova::params

  nova_config {
    'DEFAULT/compute_driver':   value => 'nova.virt.baremetal.driver.BareMetalDriver';
  }
}
