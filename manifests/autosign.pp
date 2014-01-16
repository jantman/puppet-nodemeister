# == Class: nodemeister::autosign
#
# Install Policy-Based Autosigning script on PuppetMaster, to autosign
# certificate requests for all nodes in NodeMeister ENC.
#
# See https://docs.puppetlabs.com/puppet/3.latest/reference/ssl_autosign.html#policy-based-autosigning
# and https://docs.puppetlabs.com/references/3.latest/configuration.html#autosign
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
# [*puppet_user*]
#   the user that the puppetmaster runs as
#   (defualt $nodemeister::params::puppet_user)
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
  $python_bin      = '/usr/bin/env python',
  $puppet_user     = $nodemeister::params::puppet_user
) inherits nodemeister::params {

  validate_string($enc_host) # make sure it's a string
  validate_re($enc_host, '^.+$') # make sure it's 1 char or longer
  validate_absolute_path($puppet_confdir)

  # Template uses:
  # - $python_bin
  # - $enc_host
  file {'nodemeister_autosign.py':
    ensure  => present,
    path    => "${puppet_confdir}/nodemeister_autosign.py",
    owner   => $puppet_user,
    group   => 'root',
    mode    => '0775',
    content => template('nodemeister/nodemeister_autosign.py.erb'),
  }

}
