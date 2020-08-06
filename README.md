# Usage

This docker file builds OpenSMTPD with rspamd filter.

Edit configuration at `/etc/smtpd/smtpd.conf` and mount it into the container.

A user named `vmail` is created for virtual users.
