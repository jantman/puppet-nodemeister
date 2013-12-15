# == Class: nodemeister::autosign
#
# Install and cron script to generate autosign.conf from all nodes in NodeMeister ENC.
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
# [*python_bin*]
#   which python to run the script with
#   (default '/usr/bin/env python')
#
# === Variables:
#
# This module uses no global variables.
#
# === Actions:
#
#   - template nodemeister_autosign_conf.py
#   - setup cron run of nodemeister_autosign_conf.py
#
# === Notes:
#
#
# === Examples:
#
#   class { 'nodemeister::autosign': enc_host => 'nodemeister.example.com'}
#
# === Authors:
#
# Jason Antman <jason@jasonantman.com>
#
# === Copyright
#
# Copyright 2013 Cox Media Group.
#
class nodemeister::autosign(
  $enc_host        = undef,
  $puppet_confdir  = $nodemeister::params::puppet_confdir,
  $python_bin      = '/usr/bin/env python'
) inherits nodemeister::params {

  validate_string($enc_host) # make sure it's a string
  validate_re($enc_host, '^.+$') # make sure it's 1 char or longer
  validate_absolute_path($puppet_confdir)

  $autosign_conf = "${puppet_confdir}/autosign.conf"

  # Template uses:
  # - $python_bin
  file {'nodemeister_autosign_conf.py':
    ensure  => present,
    path    => "${puppet_confdir}/nodemeister_autosign_conf.py",
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    content => template('nodemeister/nodemeister_autosign_conf.py.erb'),
  }

  cron {'nodemeister_autosign_conf.py':
    ensure  => present,
    command => "${puppet_confdir}/nodemeister_autosign_conf.py -e ${enc_host} -f ${autosign_conf}",
    user    => 'root',
    minute  => '*/5',
  }

}
