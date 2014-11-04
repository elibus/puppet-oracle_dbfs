# == Class oracle_dbfs::config
#
# This class is called from oracle_dbfs
#
class oracle_dbfs::config {

  Exec {
    path => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'
  }

  $admin_dir = "${oracle_dbfs::config_dir}/admin"
  $wallet_dir = "${oracle_dbfs::config_dir}/wallet"

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

  file { "${wallet_dir}/ewallet.p12" :
    ensure  => file,
    owner   => $oracle_dbfs::user,
    group   => $oracle_dbfs::group,
    mode    => '0660',
    content => $oracle_dbfs::ewallet,
  }

  file { "${wallet_dir}/cwallet.sso" :
    ensure  => file,
    owner   => $oracle_dbfs::user,
    group   => $oracle_dbfs::group,
    mode    => '0660',
    content => $oracle_dbfs::cwallet,
  }

  file { $wallet_dir:
    ensure => directory,
    owner  => $oracle_dbfs::user,
    group  => $oracle_dbfs::group,
    mode   => '0770',
  }

  file { $admin_dir:
    ensure => directory,
    owner  => $oracle_dbfs::user,
    group  => $oracle_dbfs::group,
    mode   => '0775',
  }

  file { $oracle_dbfs::config_dir:
    ensure  => directory,
    owner   => $oracle_dbfs::user,
    group   => $oracle_dbfs::group,
    mode    => '0775',
    require => Exec['mkdir_p config_dir']
  }

  file { "${admin_dir}/tnsnames.ora" :
    ensure  => file,
    owner   => $oracle_dbfs::user,
    group   => $oracle_dbfs::group,
    mode    => '0664',
    content => $oracle_dbfs::tnsnames,
  }

  file { "${admin_dir}/sqlnet.ora" :
    ensure  => file,
    owner   => $oracle_dbfs::user,
    group   => $oracle_dbfs::group,
    mode    => '0664',
    content => $oracle_dbfs::sqlnet,
  }

  if ( $oracle_dbfs::user_allow_other ) {
    file_line { 'fuse user_allow_other':
      path => '/etc/fuse.conf',
      line => 'user_allow_other',
    }
  }

  file { "${oracle_dbfs::config_dir}/environment" :
    ensure  => file,
    owner   => $oracle_dbfs::user,
    group   => $oracle_dbfs::group,
    mode    => '0775',
    content => template('oracle_dbfs/environment.erb'),
  }

  exec { 'mkdir_p config_dir':
    command => "mkdir -p ${oracle_dbfs::config_dir}",
    creates => $oracle_dbfs::config_dir,
  }

  User <| title == $oracle_dbfs::user |> { groups +> $oracle_dbfs::params::fuse_group }
}
