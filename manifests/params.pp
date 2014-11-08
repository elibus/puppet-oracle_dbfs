# == Class oracle_dbfs::params
#
# This class is meant to be called from oracle_dbfs
# It sets variables according to platform
#
class oracle_dbfs::params (
  $cwallet = undef,
  $ewallet = undef,
  $tnsnames = undef,
  $sqlnet = undef,
  $mounts = [],
  $user_allow_other = true,
  $config_dir = '/etc/oracle/dbfs',
  $user = 'oracle',
  $group = 'dba',
  $oracle_base = '/usr/ora11g/app/oracle',
  $oracle_home = '/usr/ora11g/app/oracle/product/11.2.0.4/client',
  $service_name = 'oracle_dbfs',
)
{
  case $::osfamily {
    'RedHat': {
      $fuse_package_name = [ 'fuse', 'fuse-libs' ]
      $fuse_group = 'fuse'
      $sysconfigdir = '/etc/sysconfig'
      $initscript = "/etc/init.d/${service_name}"
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  case $::architecture {
    'x86_64': {
      $libdir = 'lib64'
    }
    'i686': {
      $libdir = 'lib'
    }
    default: {
      fail("${::architecture} architecture not supported")
    }
  }

}
