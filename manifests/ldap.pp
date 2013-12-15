# == Class: nodemeister::ldap
#
# Setup packages and configuration required for LDAP authentication and authorization.
#
# === Parameters:
# If not specified in the class declaration, these parameters recieve their
# default values from nodemeister::params.
#
# [*python_ldap_package_name*]
#   name of the python-ldap package
#   (default $nodemeister::params::python_ldap_package_name)
#
# [*openldap_devel_package_name*]
#   name of the openldap-devel package
#   (default $nodemeister::params::openldap_devel_package_name)
#
# === Variables:
#
# This module uses no global variables.
#
# === Actions:
#   - manage python-ldap package
#   - manage openldap-devel package
#
# === Notes:
#
#
# === Examples:
#
#   class { 'nodemeister::ldap': }
#
# === Authors:
#
# Jason Antman <jason@jasonantman.com>
#
# === Copyright
#
# Copyright 2013 Cox Media Group.
#
class nodemeister::ldap(
  $python_ldap_package_name        = $nodemeister::params::python_ldap_package_name,
  $openldap_devel_package_name     = $nodemeister::params::openldap_devel_package_name,
) inherits nodemeister::params {

  package { 'python-ldap':
    ensure => present,
    name   => $python_ldap_package_name,
  }

  package { 'openldap-devel':
    ensure => present,
    name   => $openldap_devel_package_name,
  }

}
