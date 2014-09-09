# == Class: nodemeister
#
# Install, configure and manage a nodemeister installation.
#
# In addition to this class, you'll need to configure your
# puppetmasters to use NodeMeister as their ENC.
#
# === Parameters:
# If not specified in the class declaration, these parameters recieve their
# default values from nodemeister::params.
#
# [*manage_user*]
#   boolean, whether or not to manage the user and group
#   (default $nodemeister::params::manage_user)
#
# [*user*]
#   the user that nodemeister will be owned by
#   (default $nodemeister::params::user)
#
# [*group*]
#   the group that nodemeister will be owned by
#   (default $nodemeister::params::group)
#
# [*installdir*]
#   the directory to install nodemeister to, and create the venv in
#   (default $nodemeister::params::installdir)
#
# [*manage_apache*]
#   boolean, whether or not to manage the apache vhost
#   (default $nodemeister::params::manage_apache)
#
# [*vhost_hostname*]
#   hostname for the vhost
#   (default $nodemeister::params::vhost_hostname)
#
# [*htmldir*]
#   directory to symlink static HTML assets into
#   (default $nodemeister::params::htmldir)
#
# [*manage_database*]
#   boolean, if true attempt to create the postgres user, database, etc.
#   (default $nodemeister::params::manage_database)
#
# [*database_host*]
#   host or IP that the database listens on
#   (default $nodemeister::params::database_host)
#
# [*database_port*]
#   port number that the database listens on
#   (default $nodemeister::params::database_port)
#
# [*database_username*]
#   username for nodemeister to access the database
#   (default $nodemeister::params::database_username)
#
# [*database_password*]
#   password for $database_password
#   (default $nodemeister::params::database_password)
#
# [*database_name*]
#   name of the database
#   (default $nodemeister::params::database_name)
#
# [*git_url*]
#   URL to the git repository to install nodemeister from
#   (default $nodemeister::params::git_url)
#
# [*nodemeister_version*]
#   version (git ref) of nodemeister to install
#   (default $nodemeister::params::nodemeister_version)
#
# [*django_log_dir*]
#   string, absolute path to directory to put django app logs in
#   (default $nodemeister::params::django_log_dir)
#
# [*django_log_info*]
#   boolean, whether to start logging at INFO level (true) or WARNING level (false)
#   (default $nodemeister::params::django_log_info)
#
# [*django_debug*]
#   boolean, whether or not to turn Django debug logging on
#   (default: $nodemeister::params::django_debug)
#
# [*django_timezone*]
#   the timezone to use for the Django app, see http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
#   (default: $nodemeister::params::django_timezone)
#
# [*django_secret_key*]
#   the cryptographic secret_key for the Django app. This should be a 50-character random string taken from 'abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)'.
#   (default: '')
#
# [*use_ldap*]
#   boolean, whether or not to use LDAP for auth
#   (default: $nodemeister::params::use_ldap)
#
# [*ldap_server_uri*]
#   string, URI to the LDAP server, like 'ldap://ldap.example.com'
#   (default: $nodemeister::params::ldap_server_uri)
#
# [*ldap_bind_dn*]
#   string, DN to bind to the LDAP server with
#   (default: $nodemeister::params::ldap_bind_dn)
#
# [*ldap_bind_password*]
#   string, password for ldap_bind_dn
#   (default: $nodemeister::params::ldap_bind_password)
#
# [*ldap_search_dn*]
#   string, DN to search for users in, like 'ou=users,dc=example,dc=com'
#   (default: $nodemeister::params::ldap_search_dn)
#
# [*ldap_user_attr*]
#   string, Username/UID attribute in LDAP, 'uid' for normal LDAP and 'sAMAccountName' for AD
#   (default: $nodemeister::params::ldap_user_attr)
#
# [*ldap_group_search_dn*]
#   string, DN to search for groups in, like 'ou=groups,dc=example,dc=com'
#   (default: $nodemeister::params::ldap_group_search_dn)
#
# [*ldap_require_group*]
#   string, DN of a group to require membership in to login, like 'cn=encusers,ou=groups,dc=example,dc=com'
#   (default: $nodemeister::params::ldap_require_group)
#
# [*ldap_superuser_group_dn*]
#   (optional) list, DNs of group that contains Django app superusers, like 'cn=admins,ou=groups,dc=example,dc=com'
#   (default: $nodemeister::params::ldap_superuser_group_dn)
#
# === Variables:
#
# This module uses no global variables.
#
# === Actions:
#
#   - if $manage_user == true, manage user ($user) and group ($group)
#   - if $manage_apache == true, declare a nodemeister::apache class with appropriate params
#   - if $manage_database == true, declare a nodemeister::database class with appropriate params
#   - if $use_ldap == true, declare a nodemeister::ldap class with appropriate params
#   - manage $installdir directory
#   - declare a nodemeister::install class with appropriate params
#
# === Notes:
#
# If you want to run the database on another host, simply set $manage_database = false here,
# and on the other node, add something like:
#     class { 'nodemeister::database': }
# (assuming you're using the default DB name, user and password)
#
# === Examples:
#
#   class { 'nodemeister':
#     django_secret_key => '50-character alphanumeric random string',
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
class nodemeister(
  $manage_user               = $nodemeister::params::manage_user,
  $user                      = $nodemeister::params::user,
  $group                     = $nodemeister::params::group,
  $installdir                = $nodemeister::params::installdir,
  $manage_apache             = $nodemeister::params::manage_apache,
  $vhost_hostname            = $nodemeister::params::vhost_hostname,
  $htmldir                   = $nodemeister::params::htmldir,
  $manage_database           = $nodemeister::params::manage_database,
  $database_host             = $nodemeister::params::database_host,
  $database_port             = $nodemeister::params::database_port,
  $database_username         = $nodemeister::params::database_username,
  $database_password         = $nodemeister::params::database_password,
  $database_name             = $nodemeister::params::database_name,
  $git_url                   = $nodemeister::params::git_url,
  $nodemeister_version       = $nodemeister::params::nodemeister_version,
  $django_log_dir            = $nodemeister::params::django_log_dir,
  $django_log_info           = $nodemeister::params::django_log_info,
  $django_debug              = $nodemeister::params::django_debug,
  $django_timezone           = $nodemeister::params::django_timezone,
  $django_secret_key         = $nodemeister::params::django_secret_key,
  $use_ldap                  = $nodemeister::params::use_ldap,
  $ldap_server_uri           = $nodemeister::params::ldap_server_uri,
  $ldap_bind_dn              = $nodemeister::params::ldap_bind_dn,
  $ldap_bind_password        = $nodemeister::params::ldap_bind_password,
  $ldap_search_dn            = $nodemeister::params::ldap_search_dn,
  $ldap_user_attr            = $nodemeister::params::ldap_user_attr,
  $ldap_group_search_dn      = $nodemeister::params::ldap_group_search_dn,
  $ldap_require_group        = $nodemeister::params::ldap_require_group,
  $ldap_superuser_group_dn   = $nodemeister::params::ldap_superuser_group_dn,
) inherits nodemeister::params {

  validate_bool($manage_user)
  validate_bool($manage_apache)
  validate_bool($manage_database)
  validate_bool($django_debug)
  validate_bool($django_log_info)
  validate_string($django_secret_key) # make sure it's a string
  validate_re($django_secret_key, '^.*(\S+).*$') # make sure it's longer than 1 char
  validate_absolute_path($installdir)
  validate_absolute_path($htmldir)
  validate_absolute_path($django_log_dir)

  validate_bool($use_ldap)
  if($use_ldap){
    validate_string($ldap_server_uri)
    validate_re($ldap_server_uri, '^.*(\S+).*$')
    validate_string($ldap_bind_dn)
    validate_re($ldap_bind_dn, '^.*(\S+).*$')
    validate_string($ldap_bind_password)
    validate_string($ldap_search_dn)
    validate_re($ldap_search_dn, '^.*(\S+).*$')
    validate_string($ldap_user_attr)
    validate_re($ldap_user_attr, '^.*(\S+).*$')
    validate_string($ldap_group_search_dn)
    validate_re($ldap_group_search_dn, '^.*(\S+).*$')
    validate_string($ldap_require_group)

    if(!is_array($ldap_superuser_group_dn)) {
      $ldap_superuser_group_dn_arr = [$ldap_superuser_group_dn]
    } else {
      $ldap_superuser_group_dn_arr = $ldap_superuser_group_dn
    }
    validate_array($ldap_superuser_group_dn_arr)
  }
  if($ldap_require_group != '') {
    validate_re($ldap_require_group, '^.*(\S+).*$')
  }

  if ($manage_user == true) {
    user {$user:
      ensure     => present,
      comment    => 'nodemeister app user',
      gid        => $group,
      home       => $installdir,
      managehome => true,
      shell      => '/sbin/nologin',
      require    => Group[$group],
    }
    group {$group:
      ensure => present,
    }
  }

  file {$installdir:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0775',
  }

  if ($manage_apache == true) {
    class { 'nodemeister::apache':
      hostname   => $vhost_hostname,
      htmldir    => $htmldir,
      installdir => $installdir,
      user       => $user,
      group      => $group,
      require    => User[$user],
    }
  }

  if ($manage_database == true) {
    class { 'nodemeister::database':
      database_name          => $database_name,
      database_username      => $database_username,
      database_password      => $database_password,
      before                 => Class['nodemeister::apache'],
    }
  }

  if ($use_ldap == true) {
    class { 'nodemeister::ldap':
    }
  }

  class { 'nodemeister::install':
    user                    => $user,
    group                   => $group,
    installdir              => $installdir,
    htmldir                 => $htmldir,
    database_host           => $database_host,
    database_port           => $database_port,
    database_username       => $database_username,
    database_password       => $database_password,
    database_name           => $database_name,
    git_url                 => $git_url,
    nodemeister_version     => $nodemeister_version,
    django_log_dir          => $django_log_dir,
    django_debug            => $django_debug,
    django_log_info         => $django_log_info,
    django_timezone         => $django_timezone,
    django_secret_key       => $django_secret_key,
    use_ldap                => $use_ldap,
    ldap_server_uri         => $ldap_server_uri,
    ldap_bind_dn            => $ldap_bind_dn,
    ldap_bind_password      => $ldap_bind_password,
    ldap_search_dn          => $ldap_search_dn,
    ldap_user_attr          => $ldap_user_attr,
    ldap_group_search_dn    => $ldap_group_search_dn,
    ldap_require_group      => $ldap_require_group,
    ldap_superuser_group_dn => $ldap_superuser_group_dn_arr,
    before                  => Class['nodemeister::apache'],
  }

}
