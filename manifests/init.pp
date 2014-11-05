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
  $cwallet = $oracle_dbfs::params::cwallet,
  $ewallet = $oracle_dbfs::params::ewallet,
  $mounts = $oracle_dbfs::params::mounts,
  $user_allow_other = $oracle_dbfs::params::user_allow_other,
  $config_dir = $oracle_dbfs::params::config_dir,
  $tnsnames = $oracle_dbfs::params::tnsnames,
  $sqlnet = $oracle_dbfs::params::sqlnet,
  $user = $oracle_dbfs::params::user,
  $group = $oracle_dbfs::params::group,
  $oracle_base = $oracle_dbfs::params::oracle_base,
  $oracle_home = $oracle_dbfs::params::oracle_home,
  $service_name = $oracle_dbfs::params::service_name,
) inherits oracle_dbfs::params {

  # validate parameters here
  validate_absolute_path($config_dir)
  validate_bool($user_allow_other)
  validate_string($user)
  validate_string($group)
  validate_absolute_path($oracle_base)
  validate_absolute_path($oracle_home)
  validate_string($service_name)

  class { 'oracle_dbfs::install': }  ->
  class { 'oracle_dbfs::config': }   ~>
  class { 'oracle_dbfs::service': }   ->
  Class['oracle_dbfs']
}
