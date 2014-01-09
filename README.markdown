NodeMeister
===========

Purpose
-------

This module installs and configures the NodeMeister ENC. It expects you to ALREADY have
an installed and running PostGres database, and uses the system Python install.

**Be aware that this is VERY VERY ALPHA code. In its current version, it should
probably be used as an example only. Don't expect it to work, or even not
damage things, in your environment. Hopefully this will be fixed soon.**

Configuration
-------------

Usage
-----

Note that, at this time, unless specified otherwise, this module will install the
current 'master' branch of NodeMeister, and should not upgrade it ever without
being specifically told to.

Notes
-----
I haven't found a way to automate the database creation/update yet. So once this is mostly
done running on a new box, and you browse to the web UI, you'll see an error like:
    DatabaseError at /admin/
    
    relation "django_site" does not exist
at this point, `su` to the user that nodemeister runs at (nodemeister by default) and:
    su -s /bin/bash nodemeister
    cd ${installdir}
    source venv/bin/activate
    python django-nodemeister/manage.py syncdb
to initialize the database. At this point, you'll also be prompted to create a static
"superuser" username and password.

At the moment, this requires a patched version of django-fullhistory that only
exists inside CMGd. Maybe we can get a PR started for that... should talk to
rcombs and mransom. Until then, due to the limitations of the
python::virtualenv type, we need to install fullhistory separately.
