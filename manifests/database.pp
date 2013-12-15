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
) inherits nodemeister::params {

  # create the NodeMeister database
  postgresql::server::db{ $database_name:
    user     => $database_username,
    password => $database_password,
    grant    => 'ALL',
  }

}
