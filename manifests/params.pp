# == Class: nodemeister::params
#
# Defines paramaters/default values for the module.
#
# === Parameters:
#
# None.
#
# === Variables:
#
# None.
#
# === Actions:
# - Set module-internal variables
#
# === Notes:
#
#
# === Examples:
#
# Inherited by other 'nodemeister' module classes.
#
# === Authors:
#
# Jason Antman <jason@jasonantman.com>
#
# === Copyright
#
# Copyright 2013 Cox Media Group.
#
class nodemeister::params {
  $git_url                  = 'https://github.com/coxmediagroup/nodemeister.git'
  $manage_user              = true
  $user                     = 'nodemeister'
  $group                    = 'nodemeister'
  $installdir               = '/opt/nodemeister'
  $manage_apache            = true
  $vhost_hostname           = "nodemeister.${::domain}"
  $htmldir                  = "${installdir}/html"
  $manage_database          = true
  $database_host            = 'localhost'
  $database_port            = '5432'
  $database_name            = 'nodemeister'
  $database_username        = 'nodemeister'
  $database_password        = 'nodemeister'
  $nodemeister_version      = 'master'
  $django_debug             = false
  $django_log_dir           = "${installdir}/logs"
  $django_log_info          = false
  $django_timezone          = 'America/New_York'
  $django_secret_key        = ''
  $use_ldap                 = false
  $ldap_server_uri          = ''
  $ldap_bind_dn             = ''
  $ldap_bind_password       = ''
  $ldap_search_dn           = ''
  $ldap_user_attr           = 'uid'
  $ldap_group_search_dn     = ''
  $ldap_require_group       = ''
  $ldap_superuser_group_dn  = ''
  $puppet_confdir           = '/etc/puppet'
  $puppet_conf              = '/etc/puppet/puppet.conf'

  case $::osfamily {
    'RedHat', 'Linux': {
      $python_ldap_package_name    = 'python-ldap'
      $openldap_devel_package_name = 'openldap-devel'
    }
    default: {
      $python_ldap_package_name    = 'python-ldap'
      $openldap_devel_package_name = 'openldap-devel'
    }
  }

}
