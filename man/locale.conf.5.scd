locale.conf(5) "dinit-rc" "locale.conf"

# NAME

locale.conf - Configuration file for locale settings

# SYNOPSIS

/etc/locale.conf

# DESCRIPTION

The /etc/locale.conf file configures system-wide locale settings. It is read at
early boot by dinit-rc.

The format of locale.conf is a newline-separated list of environment-like
shell-compatible variable assignments, ignoring comments and empty lines.

Note that the kernel command line options _locale.LANG=_, _locale.LANGUAGE=_,
_locale.LC_CTYPE=_, _locale.LC_NUMERIC=_, _locale.LC_TIME=_,
_locale.LC_COLLATE=_, _locale.LC_MONETARY=_, _locale.LC_MESSAGES=_,
_locale.LC_PAPER=_, _locale.LC_NAME=_, _locale.LC_ADDRESS=_,
_locale.LC_TELEPHONE=_, _locale.LC_MEASUREMENT=_, _locale.LC_IDENTIFICATION=_
may be used to override the locale settings at boot.

The locale settings configured in /etc/locale.conf are system-wide and are
inherited by every service or user, unless overridden or unset by individual
programs or users.

Depending on the operating system, other configuration files might be checked
for locale configuration as well, however only as fallback.

# OPTIONS

The following locale settings may be set using /etc/locale.conf: _LANG=_,
_LANGUAGE=_, _LC_CTYPE=_, _LC_NUMERIC=_, _LC_TIME=_, _LC_COLLATE=_,
_LC_MONETARY=_, _LC_MESSAGES=_, _LC_PAPER=_, _LC_NAME=_, _LC_ADDRESS=_,
_LC_TELEPHONE=_, _LC_MEASUREMENT=_, _LC_IDENTIFICATION=_. Note that _LC_ALL_
may not be configured in this file. For details about the meaning and
semantics of these settings, refer to *locale*(7).

# EXAMPLE

*Example 1. German locale with English messages*

/etc/locale.conf:

```
# Custom settings

LANG=de_DE.UTF-8
LC_MESSAGES=en_US.UTF-8
```

# AUTHOR

This manual page was originally written for systemd v255. It has been modified
to suit Artix's current conditions and rewritten in scdoc format for easier
maintenance.
