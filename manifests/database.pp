# == Class: nodemeister::database
#
# Setup a postgres user and database for nodemeister.
#
# This class assumes you already have a running and accessible postgres instance.
#
# === Parameters:
# If not specified in the class declaration, these parameters recieve their
# default values from nodemeister::params.
#
# [*database_name*]
#   name of the database
#   (default $nodemeister::params::database_name)
#
# [*database_username*]
#   username for nodemeister to access the database
#   (default $nodemeister::params::database_username)
#
# [*database_password*]
#   password for $database_password
#  (default $nodemeister::params::database_password)
#
# [*manage_pg_hba_conf*]
#   boolean, if true add an appropriate pg_hba.conf rule for the NodeMeister database.
#   must also specify nodemeister_ips if this is specified.
#   (default: false)
#
# [*nodemeister_ips*]
#   (string or array of strings) one or array of IP addresses / pg_hba.conf host
#   specifiers to allow to access the NodeMeister database via pg_hba.conf.
#   This only takes effect if manage_pg_hba_conf is true.
#
# === Variables:
#
# This module uses no global variables.
#
# === Actions:
#   - instantiate postgres::db resource with the appropriate params
#
# === Notes:
#
#
# === Examples:
#
#   class { 'nodemeister::database': }
#
# === Authors:
#
# Jason Antman <jason@jasonantman.com>
#
# === Copyright
#
# Copyright 2013 Cox Media Group.
#
class nodemeister::database(
  $database_name             = $nodemeister::params::database_name,
  $database_username         = $nodemeister::params::database_username,
  $database_password         = $nodemeister::params::database_password,
  $manage_pg_hba_conf        = false,
  $nodemeister_ips           = undef,
) inherits nodemeister::params {

  if ( $manage_pg_hba_conf == true and $nodemeister_ips == undef) {
    fail('You must specify $nodemeister_ips if $manage_pg_hba_conf is true')
  }

  # create the NodeMeister database
  postgresql::server::db{ $database_name:
    user     => $database_username,
    password => $database_password,
    grant    => 'ALL',
  }

  postgresql::server::pg_hba_rule { 'nodemeister':
    type        => 'host',
    database    => $database_name,
    user        => $database_username,
    address     => $nodemeister_ips,
    auth_method => 'md5',
    order       => '333',
  }

}
