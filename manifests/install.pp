# == Class oracle_dbfs::install
#
class oracle_dbfs::install {

  Exec {
    path => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'
  }

  ensure_packages ( $oracle_dbfs::params::fuse_package_name )

  exec { 'create /etc/fuse.conf':
    command => 'touch /etc/fuse.conf',
    unless  => 'test -f /etc/fuse.conf'
  }

}
