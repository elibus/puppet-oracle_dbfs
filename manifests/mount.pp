# == Class: oracle_dbfs::mount
#
#
define oracle_dbfs::mount (
  $conn_string = undef,
  $mount_point = undef,
  $mount_opts = 'wallet,rw,allow_other',
)
{
  validate_string($conn_string)
  validate_absolute_path($mount_point)
  validate_string($mount_opts)

  Exec {
    path => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'
  }

  exec { "mkdir_p ${mount_point}" :
    command => "mkdir -p ${mount_point} && chown ${oracle_dbfs::user}.${oracle_dbfs::group}",
    creates => $mount_point,
  }

  concat::fragment { "Add ${mount_point} in ${oracle_dbfs::params::sysconfigdir}/oracle_dbfs.mounts":
    target  => "${oracle_dbfs::params::sysconfigdir}/oracle_dbfs.mounts",
    content => "${conn_string} ${mount_point} ${mount_opts}\n",
    order   => '10',
  }
}
