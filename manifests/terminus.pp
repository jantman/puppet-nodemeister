# == Class: nodemeister::terminus
#
# Install node terminus script, and configure puppet master to use it
#
# === Parameters:
# If not specified in the class declaration, these parameters recieve their
# default values from nodemeister::params.
#
# [*enc_host*]
#   FQDN of the NodeMeister host to use
#   (default undef, must be a string)
#
# [*puppet_confdir*]
#   puppet master config directory
#  (default $nodemeister::params::puppet_confdir)
#
# [*puppet_conf*]
#   puppet master config file
#   (puppet.conf; default $nodemeister::params::puppet_conf)
#
# === Variables:
#
# This module uses no global variables.
#
# === Actions:
#
#   - install node terminus script from template
#   - configure puppet master to use it
#
# === Notes:
#
#
# === Examples:
#
#   class { 'nodemeister::terminus': enc_host => 'nodemeister.example.com'}
#
# === Authors:
#
# Jason Antman <jason@jasonantman.com>
#
# === Copyright
#
# Copyright 2013 Cox Media Group.
#
class nodemeister::terminus(
  $enc_host        = undef,
  $puppet_conf     = $nodemeister::params::puppet_conf,
  $puppet_confdir  = $nodemeister::params::puppet_confdir,
) inherits nodemeister::params {

  validate_string($enc_host) # make sure it's a string
  validate_re($enc_host, '^.+$') # make sure it's 1 char or longer
  validate_absolute_path($puppet_confdir)
  validate_absolute_path($puppet_conf)

  Ini_setting {
      path    => $puppet_conf,
      require => File[$puppet_conf],
      notify  => Service['httpd'],
      section => 'master',
  }

  ini_setting {'puppetmasternodeterminus':
    ensure  => present,
    setting => 'node_terminus',
    value   => 'exec',
  }

  ini_setting {'puppetmasterexternalnodes':
    ensure  => present,
    setting => 'external_nodes',
    value   => "${puppet_confdir}/nodemeister_terminus.sh",
    require => [Ini_setting['puppetmasternodeterminus'], File['nodemeister_terminus.sh']],
  }

  # Template uses:
  # - $enc_host
  file {'nodemeister_terminus.sh':
    ensure  => present,
    path    => "${puppet_confdir}/nodemeister_terminus.sh",
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    content => template('nodemeister/nodemeister_terminus.sh.erb'),
  }

}
