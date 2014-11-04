# == Class oracle_dbfs::service
#
# This class is meant to be called from oracle_dbfs
# It sets variables according to platform
#

class oracle_dbfs::service {
  Exec {
    path => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'
  }

  exec { 'mount oracle_dbfs':
    command   => "${oracle_dbfs::config_dir}/dbfs_mount.sh",
    refresh   => "cat /proc/mounts | cut -f2 -d \" \" | grep ${oracle_dbfs::mount_point} > /dev/null",
    require   => Exec['umount oracle_dbfs'],
    logoutput => true,
  }

  exec { 'umount oracle_dbfs':
    command     => "umount ${oracle_dbfs::mount_point}",
    refreshonly => true,
    onlyif      => "cat /proc/mounts | cut -f2 -d \" \" | grep ${oracle_dbfs::mount_point} > /dev/null",
  }
}

