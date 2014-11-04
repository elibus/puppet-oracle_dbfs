# == Class: oracle_dbfs
#
# Full description of class oracle_dbfs here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class oracle_dbfs (
  $mount_point = undef,
  $conn_string = '',
  $mount_opts = 'rw,user,noauto',
  $tns_admin_dir = '$CDPATH',
  $user = $::oradb::client::user,
  $group = $::oradb::client::group,
  $oracle_base = $::oradb::client::oracleBase,
  $oracle_home = $::oradb::client::oracleHome,
) inherits oracle_dbfs::params {

  include oradb::client

  # validate parameters here
  validate_absolute_path($mount_point)
  validate_string($conn_string)
  validate_string($opts)
  validate_absolute_path($tns_admin_dir)
  validate_string($user)
  validate_string($group)
  validate_absolute_path($oracle_base)
  validate_absolute_path($oracle_home)

  class { 'oracle_dbfs::install': } ->
  class { 'oracle_dbfs::config': } ~>
  class { 'oracle_dbfs::service': } ->
  Class['oracle_dbfs']
}
