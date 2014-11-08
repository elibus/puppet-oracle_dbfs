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

  file { "/usr/local/${oracle_dbfs::params::libdir}/libfuse.so":
    ensure => link,
    target => "${oracle_dbfs::params::libdir}/libfuse.so.2"
  }

  exec { 'Exec ldconfig after libfuse.so link':
    command => 'ldconfig',
    require => File["/usr/local/${oracle_dbfs::params::libdir}/libfuse.so"]
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

  exec { 'mkdir_p config_dir':
    command => "mkdir -p ${oracle_dbfs::config_dir}",
    creates => $oracle_dbfs::config_dir,
  }

  file { "${oracle_dbfs::params::sysconfigdir}/${oracle_dbfs::service_name}" :
    content => template('oracle_dbfs/oracle_dbfs-sysconfig.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  concat { "${oracle_dbfs::params::sysconfigdir}/oracle_dbfs.mounts":
    mode  => '0644',
    owner => 'root',
    group => 'root',
  }

  concat::fragment { "Add header in ${oracle_dbfs::params::sysconfigdir}/oracle_dbfs.mounts":
    target  => "${oracle_dbfs::params::sysconfigdir}/oracle_dbfs.mounts",
    content => "#This file is managed by puppet!\n",
    order   => '01',
  }

  create_resources('oracle_dbfs::mount', $oracle_dbfs::mounts)

  User <| title == $oracle_dbfs::user |> { groups +> $oracle_dbfs::params::fuse_group }
}
