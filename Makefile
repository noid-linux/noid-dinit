PREFIX      ?= /usr
SYSCONFDIR  ?= /etc
BINDIR      ?= $(PREFIX)/bin
DATADIR     ?= $(PREFIX)/share
LIBDIR      ?= $(PREFIX)/lib
MANDIR      ?= $(DATADIR)/man/man8
DINITDIR    ?= $(SYSCONFDIR)/dinit.d
DINITLIBDIR ?= $(LIBDIR)/dinit.d

BIN_PROGRAMS = modules-load

MANPAGES = modules-load.8

CONF_FILES = \
	cgroups.conf \
	hwclock.conf \
	rc.local \
	rc.shutdown

SERVICEDIR = boot.d \
	mount.d

SERVICES = \
	binfmt \
	boot \
	cgroups \
	cleanup \
	dmesg \
	fsck \
	hostname \
	hwclock \
	kmod-static-nodes \
	loginready \
	misc \
	modules \
	mount \
	mount-all \
	net-lo \
	network \
	pseudofs \
	random-seed \
	rclocal \
	recovery \
	root-rw \
	setup \
	single \
	swap \
	sysusers \
	tmpfiles-dev \
	tmpfiles-setup \
	tmpfs \
	tty1 \
	tty2 \
	tty3 \
	tty4 \
	tty5 \
	tty6 \
	udevd \
	udev-settle \
	udev-trigger \
	vconsole


SCRIPTS = \
	binfmt \
	cgroup-release-agent.sh \
	cgroups \
	cleanup \
	dmesg \
	hostname \
	hwclock \
	network \
	pseudofs \
	random-seed \
	vconsole

all:
	@echo "Nothing to be done here."

install:
	install -d $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(DATADIR)
	install -d $(DESTDIR)$(SYSCONFDIR)
	install -d $(DESTDIR)$(MANDIR)
	install -d $(DESTDIR)$(DINITLIBDIR)
	install -d $(DESTDIR)$(DINITLIBDIR)/scripts
	install -d $(DESTDIR)$(DINITLIBDIR)/boot.d
	install -d $(DESTDIR)$(DINITLIBDIR)/mount.d
	# placeholder
	touch $(DESTDIR)$(DINITLIBDIR)/mount.d/.KEEP
	# default services
	ln -sf ../loginready $(DESTDIR)$(DINITLIBDIR)/boot.d/loginready
	ln -sf ../misc $(DESTDIR)$(DINITLIBDIR)/boot.d/misc
	# config files
	for conf in $(CONF_FILES); do \
		install -m 644 config/$$conf $(DESTDIR)$(DINITDIR); \
	done
	# scripts
	for script in $(SCRIPTS); do \
		install -m 755 scripts/$$script $(DESTDIR)$(DINITLIBDIR)/scripts; \
	done
	# programs
	for prog in $(BIN_PROGRAMS); do \
		install -m 755 bin/$$prog $(DESTDIR)$(BINDIR); \
	done
	# manpages
	for man in $(MANPAGES); do \
		install -m 644 man/$$man $(DESTDIR)$(MANDIR); \
	done
	# services
	for srv in $(SERVICES); do \
		install -m 644 services/$$srv $(DESTDIR)$(DINITLIBDIR); \
	done
