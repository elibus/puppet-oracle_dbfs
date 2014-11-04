# == Class oracle_dbfs::config
#
# This class is called from oracle_dbfs
#
class oracle_dbfs::config {

  Exec {
    path => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'
  }

  file { '/usr/local/lib64/libfuse.so':
    ensure => link,
    target => "${oracle_dbfs::params::libdir}/libfuse.so.2"
  }

  file { $oracle_dbfs::mount_point :
    ensure => directory,
    owner  => $oracle_dbfs::user,
    group  => $oracle_dbfs::group,
    mode   => '0755'
  }

  file { $oracle_dbfs::ewallet :
    ensure  => file,
    owner   => $oracle_dbfs::user,
    group   => $oracle_dbfs::group,
    mode    => '0660',
    content => $oracle_dbfs::ewallet_content,
  }

  file { $oracle_dbfs::cwallet :
    ensure  => file,
    owner   => $oracle_dbfs::user,
    group   => $oracle_dbfs::group,
    mode    => '0660',
    content => $oracle_dbfs::cwallet_content,
  }

  $wallet_dir = dirname($oracle_dbfs::ewallet)
  file { $wallet_dir:
    ensure  => directory,
    owner   => $oracle_dbfs::user,
    group   => $oracle_dbfs::group,
    mode    => '0770',
    require => Exec[$wallet_dir],
  }

  exec { $wallet_dir:
    command => "mkdir -p ${wallet_dir}",
    creates => $wallet_dir,
  }

  ensure_resource( 'file', $oracle_dbfs::tns_admin_dir, {
      ensure  => directory,
      owner   => $oracle_dbfs::user,
      group   => $oracle_dbfs::group,
      mode    => '0775',
      require => Exec[$wallet_dir],
    }
  )

  file { "${oracle_dbfs::tns_admin_dir}/tnsnames.ora" :
    ensure  => file,
    owner   => $oracle_dbfs::user,
    group   => $oracle_dbfs::group,
    mode    => '0770',
    content => $oracle_dbfs::tnsnames,
  }

  file { "${oracle_dbfs::tns_admin_dir}/sqlnet.ora" :
    ensure  => file,
    owner   => $oracle_dbfs::user,
    group   => $oracle_dbfs::group,
    mode    => '0770',
    content => $oracle_dbfs::sqlnet,
  }

  if ( $oracle_dbfs::user_allow_other ) {
    file_line { 'fuse user_allow_other':
      path => '/etc/fuse.conf',
      line => 'user_allow_other',
    }
  }

  User <| title == $oracle_dbfs::user |> { groups +> $oracle_dbfs::params::fuse_group }
}
