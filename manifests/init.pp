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
  $conn_string = $oradb::params::conn_string,
  $mount_point = $oradb::params::mount_point,
  $mount_opts = $oradb::params::mount_opts,
  $cwallet = $oracle_dbfs::params::cwallet,
  $ewallet = $oracle_dbfs::params::ewallet,
  $cwallet_content = $oracle_dbfs::params::cwallet_content,
  $ewallet_content = $oracle_dbfs::params::ewallet_content,
  $user_allow_other = $oracle_dbfs::params::user_allow_other,
  $tns_admin_dir = $oracle_dbfs::params::tns_admin_dir,
  $tnsnames = $oracle_dbfs::params::tnsnames,
  $sqlnet = $oracle_dbfs::params::sqlnet,
  $user = $oracle_dbfs::params::user,
  $group = $oracle_dbfs::params::group,
  $oracle_base = $oracle_dbfs::params::oracle_base,
  $oracle_home = $oracle_dbfs::params::oracle_home,
) inherits oracle_dbfs::params {

  # validate parameters here
  validate_string($conn_string)
  validate_absolute_path($mount_point)
  validate_string($mount_opts)
  validate_absolute_path($cwallet)
  validate_absolute_path($ewallet)
  validate_absolute_path($tns_admin_dir)
  validate_string($user)
  validate_string($group)
  validate_absolute_path($oracle_base)
  validate_absolute_path($oracle_home)

  class { 'oracle_dbfs::install': }  ->
  class { 'oracle_dbfs::config': }   ~>
  class { 'oracle_dbfs::service': }  ->
  Class['oracle_dbfs']
}
