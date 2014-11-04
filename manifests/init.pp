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
  $conn_string = $::oradb::params::conn_string,
  $mount_point = $::oradb::params::mount_point,
  $mount_opts = $::oradb::params::mount_opts,
  $configure_fstab = $::oradb::params::configure_fstab,
  $oracle_dbfs::user_allow_other = $oracle_dbfs::params::user_allow_other,
  $tns_admin_dir = $::oradb::params::tns_admin_dir,
  $user = $::oradb::client::user,
  $group = $::oradb::client::group,
  $oracle_base = $::oradb::client::oracleBase,
  $oracle_home = $::oradb::client::oracleHome,
) inherits oracle_dbfs::params {

  include oradb::client

  # validate parameters here
  validate_string($conn_string)
  validate_absolute_path($mount_point)
  validate_string($mount_opts)
  validate_boolean($configure_fstab)
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
