# == Class oracle_dbfs::service
#
# This class is meant to be called from oracle_dbfs
# It ensure the service is running
#
class oracle_dbfs::service {

  service { $oracle_dbfs::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
