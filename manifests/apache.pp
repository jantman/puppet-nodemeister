# == Class: nodemeister::apache
#
# Configure apache web server for the nodemeister vhost
#
# === Parameters:
# If not specified in the class declaration, these parameters recieve their
# default values from nodemeister::params.
#
# [*hostname*]
#   hostname for the vhost
#   (default $nodemeister::params::vhost_hostname)
#
# [*htmldir*]
#   directory to symlink static HTML assets into
#   ( default $nodemeister::params::htmldir)
#
# [*installdir*]
#   the directory to install nodemeister to, and create the venv in
#   (default $nodemeister::params::installdir)
#
# [*user*]
#   the user that nodemeister will be owned by
#   (default $nodemeister::params::user)
#
# [*group*]
#   the group that nodemeister will be owned by
#   (default $nodemeister::params::group)
#
#
# === Variables:
#
# This module uses no global variables.
#
# === Actions:
#   - include apache
#   - include apache::mod::python
#   - include apache::mod::alias
#   - define an instance of apache::mod::wsgi
#   - define an apache::vhost for nodemeister
#
# === Notes:
#
#
# === Examples:
#
# Under normal circumstances, this class should be instantiated by
# the main nodemeister class, when $manage_apache == true.
# For more customization:
#
#   class { 'nodemeister::apache':
#     hostname => 'nodemeister.example.com'
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
class nodemeister::apache(
  $hostname    = $nodemeister::params::vhost_hostname,
  $htmldir     = $nodemeister::params::htmldir,
  $installdir  = $nodemeister::params::installdir,
  $user        = $nodemeister::params::user,
  $group       = $nodemeister::params::group,
) inherits nodemeister::params {
  include ::apache
  include ::apache::mod::python
  include ::apache::mod::alias

  class { '::apache::mod::wsgi':
    wsgi_socket_prefix => '/var/run/wsgi',
  }

  apache::vhost { 'nodemeister':
    ensure                      => 'present',
    port                        => '80',
    vhost_name                  => '*',
    servername                  => 'nodemeister',
    serveraliases               => [$::hostname, $::fqdn, "nodemeister.${::domain}"],
    docroot                     => $htmldir,
    aliases                     => [
      {
        alias => '/static/admin/',
        path  => "${htmldir}/admin/static/admin/"
      },
      {
        alias => '/static/rest_framework/',
        path  => "${htmldir}/rest_framework/static/rest_framework/"
      },
    ],
    wsgi_script_aliases         => {
      '/' => "${installdir}/django-nodemeister/nodemeister/wsgi.py"
    },
    wsgi_daemon_process         => 'nodemeister',
    wsgi_daemon_process_options => {
      processes    => '2',
      threads      => '15',
      display-name => 'nodemeister',
      python-path  => "${installdir}/django-nodemeister/:${installdir}/venv/lib/python2.6/site-packages",
      user         => $user,
    },
    wsgi_process_group          => 'nodemeister',
    docroot_owner               => $user,
    docroot_group               => $group,
    ssl                         => false,
    options                     => ['FollowSymLinks'],
    override                    => ['None'],
  }

}
