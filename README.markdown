####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with oracle_dbfs](#setup)
    * [What oracle_dbfs affects](#what-oracle_dbfs-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with oracle_dbfs](#beginning-with-oracle_dbfs)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module configure the Oracle DBFS as a Unix Service on RHEL 6 systems (should work on 7 in compatibility)

##Module Description

This module configure Oracle DBFS as a service and mount all defined remote file systems at boot.
This is particularly useful as Oracle does not provide a way to automount DBFS (do not refer to the Oracle
DBFS documentation because what's declared is NOT working)


##Setup

###What oracle_dbfs affects

This is what this module will alter:
* Create `/etc/sysconfig/oracle_dbfs`
* Create `/etc/sysconfig/oracle_dbfs.mounts` a fstab like file for your mounts
* Create `/etc/init.d/oracle_dbfs`, chkconfig on the service and ensure it is running
* Add the oracle user to the fuse group
* Ensure packages `fuse, fuse-libs` are installed
* touch `/etc/fuse.conf` and (if configured) ensure `allow_other` option is present
* Create `/etc/oracle/dbfs/{admin,wallet}` where to store `tnsnames.ora,sqlnet.ora` and wallet files
* Create any required mount point with owner oracle and related group (as configured)


###Setup Requirements

This module requires:
* Oracle client is installed and working. You might want to try this module for installing the client: https://forge.puppetlabs.com/biemond/oradb

###Beginning with oracle_dbfs

This is a simpe use of the modules:

      include oracle_dbfs {
        user        => 'oracle',
        group       => 'dba',
        oracle_base => '/usr/ora11g/app/oracle',
        oracle_home => '/usr/ora11g/app/oracle/product/11.2.0.4/client',
        ewallet     => 'ewallet content',
        cwallet     => 'cwallet content',
        tnsnames    => 'tnsnames content',
        sqlnet      => 'sqlnet content',
        mounts      => {
          '/mnt/dbfs' => {
            'conn_string' => 'dbfs@DBFS',
            'mount_point' => '/mnt/dbfs',
          },
        }
      }

Defaults:

| Option          | Defaults to                                     | Description                                             |
|------------------|------------------------------------------------|---------------------------------------------------------|
| user_allow_other | true                                           | puts in /etc/fuse.conf                                  |
| config_dir       | /etc/oracle/dbfs                               | Where to store wallet and tnsnames/sqlnet.ora files     |
| user             | oracle                                         | Self explanatory                                        |
| group            | dba                                            | Self explanatory                                        |
| oracle_base      | /usr/ora11g/app/oracle                         | Self explanatory                                        |
| oracle_home      | /usr/ora11g/app/oracle/product/11.2.0.4/client | Self explanatory                                        |
| service_name     | oracle_dbfs                                    | Self explanatory                                        |

##Usage


To take the most out of this module I recommend using hiera + the hiera-file backend.
This is an example using hiera:

      include oracle_dbfs

Hiera config file:

      ---
      oracle_dbfs:
        user:             'oracle'
        group:            'dba'
        oracle_base:      '/usr/ora11g/app/oracle'
        oracle_home:      '/usr/ora11g/app/oracle/product/11.2.0.4/client'
        config_dir:       '/etc/oracle/dbfs'
        user_allow_other: true
        mounts:
          '/mnt/oradbfs'
            conn_string: 'dbfs_user@DBFS'
            mount_point: '/mnt/oradbfs'
            mount_opts:  'waller,rw,allow_other'
          '/mnt/anotheroradbfs'
            conn_string: 'dbfs_user@DBFS'
            mount_point: '/mnt/anotheroradbfs'
            mount_opts:  'waller,rw,allow_other'

Then somewhere under your hiera hierarchy creates the following files:

      /etc/puppet/data/hiera/common:
        oracle_dbfs::cwallet
        oracle_dbfs::ewallet
        oracle_dbfs::tnsnames
        oracle_dbfs::sqlnet


##Reference

Here, list the classes, types, providers, facts, etc contained in your module. This section should include all of the under-the-hood workings of your module so people know what the module is touching on their system but don't need to mess with things. (We are working on automating this section!)

##Limitations

This module has been tested only on RHEL 6. It should work on RHEL 7 and Centos.

##Development

Since your module is awesome, other users will want to play with it. Let them know what the ground rules for contributing are.

