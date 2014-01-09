# == Class: nodemeister::install
#
# Install nodemeister - git clone, directory creation, etc.
#
# === Parameters:
# If not specified in the class declaration, these parameters recieve their
# default values from nodemeister::params.
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
# [*htmldir*]
#   directory to symlink static HTML assets into
#   (default $nodemeister::params::htmldir)
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
#   (optional) string, DN of group that contains Django app superusers, like 'cn=admins,ou=groups,dc=example,dc=com'
#   (default: $nodemeister::params::ldap_superuser_group_dn)
#
# === Variables:
#
# This module uses no global variables.
#
# === Actions:
#   - require postgresql::python
#   - manage $htmldir directory, subdirectories and symlinks
#   - manage python::virtualenv for nodemeister, at $installdir/venv
#   - separately manage pip install of CMGd fullhistory module
#   - manage NodeMeister source code checkout as a vcsrepo type
#   - manage $django_log_dir directory
#   - manage NodeMeister settings.py from template
#   - validate DB connection
#
# === Notes:
#
# === Examples:
#
#   class { 'nodemeister::install':
#     nodemeister_version => 'master',
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
class nodemeister::install(
  $user                      = $nodemeister::params::user,
  $group                     = $nodemeister::params::group,
  $installdir                = $nodemeister::params::installdir,
  $htmldir                   = $nodemeister::params::htmldir,
  $database_host             = $nodemeister::params::database_host,
  $database_port             = $nodemeister::params::database_port,
  $database_username         = $nodemeister::params::database_username,
  $database_password         = $nodemeister::params::database_password,
  $database_name             = $nodemeister::params::database_name,
  $git_url                   = $nodemeister::params::git_url,
  $nodemeister_version       = $nodemeister::params::nodemeister_version,
  $django_log_dir            = $nodemeister::params::django_log_dir,
  $django_debug              = $nodemeister::params::django_debug,
  $django_log_info           = $nodemeister::params::django_log_info,
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

  # for psycopg2 package
  require postgresql::lib::python

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
    validate_string($ldap_superuser_group_dn)
  }
  if($ldap_require_group != '') {
    validate_re($ldap_require_group, '^.*(\S+).*$')
  }
  if($ldap_superuser_group_dn != '') {
    validate_re($ldap_superuser_group_dn, '^.*(\S+).*$')
  }

  # make docroot
  file { $htmldir:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }

  # admin static resource dirs and symlinks
  file { "${htmldir}/admin":
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }
  file { "${htmldir}/admin/static":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => File["${htmldir}/admin"]
  }
  file { "${htmldir}/admin/static/admin":
    ensure  => link,
    target  => "${installdir}/venv/lib/python2.6/site-packages/django/contrib/admin/static/admin",
    require => File["${htmldir}/admin/static"],
  }

  # rest_framework static resource dirs and symlinks
  file { "${htmldir}/rest_framework":
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }
  file { "${htmldir}/rest_framework/static":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => File["${htmldir}/rest_framework"]
  }
  file { "${htmldir}/rest_framework/static/rest_framework":
    ensure  => link,
    target  => "${installdir}/venv/lib/python2.6/site-packages/rest_framework/static/rest_framework",
    require => File["${htmldir}/rest_framework/static"],
  }


  # install the venv in installdir/venv; see requirements.txt
  python::virtualenv {"${installdir}/venv":
    ensure            => present,
    python            => '/usr/bin/python',
    packages          => [
      'Django==1.5.1',
      'Markdown==2.3.1',
      'PyYAML==3.10',
      'anyjson==0.3.1',
      'django-auth-ldap==1.1.4',
      'django-filter==0.6',
      'django-jsonfield==0.9.10',
      'django-tastypie==0.9.14',
      'djangorestframework==2.3.2',
      'iniparse==0.3.1',
      'jsonfield==0.9.17',
      'mimeparse==0.1.3',
      'psycopg2',
      'python-cjson==1.0.5',
      'python-dateutil==2.1',
      'simplejson==3.3.0',
      'six==1.3.0',
      'south==0.7.6',
      ],
    user              => $user,
    group             => $group,
    require           => Package['python-psycopg2'],
  }

  # the fullhistory package that we're using (django 1.5 compatible) is a
  # local CMGd patched version of the current 0.3.1 upstream. The pull request
  # for it is still open:
  # https://github.com/cuker/django-fullhistory/pull/3
  # Until that's merged and released to PyPI, we need to install the branch
  # that PR is based off of.
  $fullhistory_egg = "git+http://github.com/RobCombs/django-fullhistory.git@0.3.2#egg=fullhistory"
  exec { 'install-fullhistory-fork':
    user      => $user,
    group     => $group,
    cwd       => "${installdir}/venv",
    command   => "${installdir}/venv/bin/pip install -e ${fullhistory_egg}",
    creates   => "${installdir}/venv/lib/python2.6/site-packages/fullhistory",
    logoutput => on_failure,
    tries     => 3,
    try_sleep => 3,
    require   => Python::Virtualenv["${installdir}/venv"],
  }

  vcsrepo { "${installdir}/django-nodemeister":
    ensure   => present,
    provider => git,
    source   => $git_url,
    revision => $::nodemeister_version,
    owner    => $user,
    group    => $group,
  }

  file { $django_log_dir:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0775',
  }

  # Template uses:
  # - $django_debug
  # - $database_name
  # - $database_username
  # - $database_password
  # - $database_host
  # - $database_port
  # - $django_timezone
  # - $django_secret_key
  # - $use_ldap
  # - $ldap_server_uri
  # - $ldap_bind_dn
  # - $ldap_bind_password
  # - $ldap_search_dn
  # - $ldap_user_attr
  # - $ldap_group_search_dn
  # - $ldap_require_group
  # - $ldap_superuser_group_dn
  # - $django_log_dir
  # - $django_log_info
  file { "${installdir}/django-nodemeister/nodemeister/settings.py":
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('nodemeister/settings.py.erb'),
    require => [Vcsrepo["${installdir}/django-nodemeister"], File[$django_log_dir]],
    notify  => Service['httpd'],
  } ->
  postgresql::validate_db_connection { 'validate_nodemeister_dbconn':
    database_host     => $database_host,
    database_username => $database_username,
    database_password => $database_password,
    database_name     => $database_name,
    subscribe         => File["${installdir}/django-nodemeister/nodemeister/settings.py"],
  }

}
