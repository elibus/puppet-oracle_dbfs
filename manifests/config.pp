# == Class oracle_dbfs::config
#
# This class is called from oracle_dbfs
#
class oracle_dbfs::config {

  file { '/usr/local/lib64/libfuse.so':
    ensure  => link,
    target => '/lib64/libfuse.so.2'
  }

  file { $oracle_dbfs::mount_point :
    ensure  => directory,
    owner   => $root,
    group   => $root,
    mode    => '0755'
  }

  file { $oracle_dbfs::ewallet :
    ensure  => file,
    owner   => $oracle_client::oracle_user,
    group   => $oracle_client::oracle_group,
    mode    => '0660',
    content => $oracle_dbfs::ewallet,
  }

  file { $oracle_dbfs::cwallet :
    ensure  => file,
    owner   => $oracle_client::oracle_user,
    group   => $oracle_client::oracle_group,
    mode    => '0660',
    content => $oracle_dbfs::ewallet,
  }

  $wallet_dir = dirname($oracle_dbfs::ewallet)
  file { $wallet_dir:
    ensure => directory,
    owner  => $oracle_client::oracle_user,
    group  => $oracle_client::oracle_group,
    mode   => '0770'
  }

  file { "${oracle_dbfs::oracle_home}/bin/dbfs_client" :
    owner => 'root',
    group => $oracle_dbfs::params::fuse_group,
    mode  => '4570',
  }

  file { "/sbin/mount.dbfs" :
    ensure => link,
  }

  if ( $oracle_dbfs::user_allow_other ) {
    file_line { 'fuse user_allow_other':
      path => '/etc/fuse.conf',
      line => "user_allow_other",
    }
  }

  if ( $oracle_dbfs::configure_fstab ) {
    file_line { 'fstab_rule':
      path => '/etc/fstab',
      line => "/sbin/mount.dbfs#/@${oracle_dbfs::conn_string} ${oracle_dbfs::mount_point} ${oracle_dbfs::params::fuse_group} rw,user,noauto 0 0",
    }
  }

  User <| title == $oracle_client::oracle_user |> { groups +> $oracle_dbfs::params::fuse_group }
}
