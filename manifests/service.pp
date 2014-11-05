# == Class oracle_dbfs::service
#
# This class is called from oracle_dbfs
#
class oracle_dbfs::service {

  service { $oracle_dbfs::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
