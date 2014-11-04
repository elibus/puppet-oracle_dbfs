# == Class oracle_dbfs::install
#
class oracle_dbfs::install {

  ensure_packages { $oracle_dbfs::params::fuse_package_name :
    ensure => present,
  }
}
