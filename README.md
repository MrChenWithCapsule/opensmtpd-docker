# Usage

OpenSMTPD with filter-dkimsign and filter-senderscore.

Edit configuration at `/etc/smtpd/smtpd.conf` and mount it into the container.

A `vmail` user is created for virtual users, and `dkimsign (957:957)` for dkim.
