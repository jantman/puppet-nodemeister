# == Class: nodemeister::backup
#
# Cron a recurring backup of nodemeister every X hours, keeping Y days of backups.
#
# === Parameters:
# If not specified in the class declaration, these parameters recieve their
# default values from nodemeister::params.
#
# [*save_dir*]
#   (string/absolute path) the directory to save the backups in
#
# [*keep_days*]
#   (integer) keep backups up to this many days old
#   (default 30)
#
# [*cron_hour*]
#   (string) a crontab-style hour specification of how often to run the backup script
#   (default: '*/12', every 12 hours)
#
# [*pg_dump_path*]
#   (string, absolute path) the path to the pg_dump binary to use
#   (default: '/usr/bin/pg_dump')
#
# === Variables:
#
# This module uses no global variables.
#
# === Actions:
#   - manage a backup script on disk, from template
#   - optionally, manage the destination directory for backups
#   - run the script via cron on a recurring basis
#
# === Notes:
#
# === Examples:
#
#   class { 'nodemeister::backup':
#     save_dir => '/mnt/scripted_backups/nodemeister/',
#   }
#
# === Authors:
#
# Jason Antman <jason@jasonantman.com>
#
# === Copyright
#
# Copyright 2013 Cox Media Group.
#
class nodemeister::backup (
  $save_dir  = undef,
  $keep_days = 30,
  $cron_hour = '*/12',
  $pg_dump_path = '/usr/bin/pg_dump',
) {
  require nodemeister

  validate_absolute_path($save_dir)
  validate_re($keep_days, '^[0-9]+$')
  validate_absolute_path($pg_dump_path)

  $script_path = "${nodemeister::installdir}/backup_nodemeister.sh"

  file { $save_dir:
    ensure => directory,
    owner  => $nodemeister::params::user,
    group  => $nodemeister::params::group,
    mode   => '0777',
  }

  # cron to run this. How do we allow a variable for how often to run? Do we just say every X hours, pass in X, use "*/${X}" ???
  cron { 'backup_nodemeister.sh':
    ensure  => present,
    command => $script_path,
    hour    => $cron_hour,
    minute  => 0,
    user    => $nodemeister::params::user,
    require => File['backup_nodemeister.sh'],
  }

  $database_host = $nodemeister::database_host
  $database_port = $nodemeister::database_port
  $database_username = $nodemeister::database_username
  $database_name = $nodemeister::database_name
  $database_password = $nodemeister::database_password

  $pgpass_path = "${nodemeister::installdir}/.pgpass"

  file { 'nodemeister-pgpass':
    ensure  => present,
    path    => $pgpass_path,
    owner   => $nodemeister::params::user,
    group   => $nodemeister::params::group,
    mode    => '0600',
    content => "${database_host}:${database_port}:${database_name}:${database_username}:${database_password}",
  }

  # Template Uses:
  # - $save_dir
  # - $keep_days
  # - $::hostname
  # - $database_host
  # - $database_port
  # - $database_username
  # - $database_name
  # - $pgpass_path
  # - $pg_dump_path
  file { 'backup_nodemeister.sh':
    ensure  => present,
    path    => $script_path,
    owner   => $nodemeister::params::user,
    group   => $nodemeister::params::group,
    mode    => '0755',
    content => template('nodemeister/backup_nodemeister.sh.erb'),
    require => [ File['nodemeister-pgpass'], File[$save_dir] ],
  }

}
