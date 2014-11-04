# == Class oracle_dbfs::params
#
# This class is meant to be called from oracle_dbfs
# It sets variables according to platform
#
class oracle_dbfs::params (
  $conn_string = undef,
  $mount_point = undef,
  $cwallet_content = undef,
  $ewallet_content = undef,
  $tnsnames = undef,
  $sqlnet = undef,
  $mount_opts = '-o rw -o user -o noauto',
  $cwallet = '/etc/oracle/dbfs/wallet/cwallet.sso',
  $ewallet = '/etc/oracle/dbfs/wallet/ewallet.p12',
  $user_allow_other = true,
  $tns_admin_dir = '/etc/oracle/dbfs/admin',
  $user = 'oracle',
  $group = 'dba',
  $oracle_base = '/usr/ora11g/app/oracle',
  $oracle_home = '/usr/ora11g/app/oracle/product/11.2.0.4/client',
)
{
  case $::osfamily {
    'RedHat': {
      $fuse_package_name = [ 'fuse', 'fuse-libs' ]
      $fuse_group = 'fuse'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  case $::architecture {
    'x86_64': {
      $libdir = '/lib64'
    }
    'i686': {
      $libdir = '/lib'
    }
    default: {
      fail("${::architecture} architecture not supported")
    }
  }

}
