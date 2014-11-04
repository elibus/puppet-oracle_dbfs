# == Class oracle_dbfs::params
#
# This class is meant to be called from oracle_dbfs
# It sets variables according to platform
#
class oracle_dbfs::params (
  $conn_string = undef,
  $mount_point = undef,
  $mount_opts = 'rw,user,noauto',
  $configure_fstab = false,
  $oracle_dbfs::params::user_allow_other = true,
  $tns_admin_dir = '$CDPATH',
  $oracle_user = $::oradb::client::oracle_user,
  $oracle_group = $::oradb::client::oracle_group,
  $oracle_base = $::oradb::client::oracle_base,
  $oracle_home = $::oradb::client::oracle_home,
)
{
  case $::osfamily {
    'RedHat': {
      $fuse_package_name = 'libfuse'
      $fuse_group = 'fuse'
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
