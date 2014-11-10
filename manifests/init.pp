# == Class: oracle_dbfs
#
# This module configure the Oracle DBFS as a Unix Service on RHEL 6 systems (should work on 7 in compatibility)
#
# === Parameters
#
# [*user*]
#   Oracle user
# [*group*]
#   Oracle group.
# [*oracle_base*]
#   Oracle base installation.
# [*oracle_home*]
#   oracle home.
# [*cwallet*]
#   Wallet file.
# [*ewallet*]
#   Wallet file.
# [*tnsnames*]
#   tnsnames.ora file content.
# [*sqlnet*]
#   sqlnet.ora file content.
# [*user_allow_other*]
#   configure "allow_other" in /etc/fuse.conf if true.
# [*service_name*]
#   service name for mounting the remote fs.
# [*mounts*]
#   Array of mount points and relative configuration.
#
# Sample usage:
#      include oracle_dbfs {
#        user        => 'oracle',
#        group       => 'dba',
#        oracle_base => '/usr/ora11g/app/oracle',
#        oracle_home => '/usr/ora11g/app/oracle/product/11.2.0.4/client',
#        ewallet     => 'ewallet content',
#        cwallet     => 'cwallet content',
#        tnsnames    => 'tnsnames content',
#        sqlnet      => 'sqlnet content',
#        mounts      => {
#          '/mnt/dbfs' => {
#            'conn_string' => 'dbfs@DBFS',
#            'mount_point' => '/mnt/dbfs',
#          },
#        }
#      }

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
