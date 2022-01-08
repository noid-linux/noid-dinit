PREFIX        ?= /usr
SYSCONFDIR    ?= /etc
LOCALSTATEDIR ?= /var
BINDIR        ?= $(PREFIX)/bin
LIBDIR        ?= $(PREFIX)/lib
DATADIR       ?= $(PREFIX)/share
MANDIR        ?= $(DATADIR)/man/man8
DINITDIR      ?= $(SYSCONFDIR)/dinit.d

BIN_PROGRAMS = modules-load

MANPAGES = modules-load.8

CONF_FILES = \
	cgroups.conf \
	hwclock.conf \
	rc.local \
	rc.shutdown

SERVICEDIR = boot.d \
	mount.d \
	getty.d

SERVICES = \
	binfmt \
	boot \
	cgroups \
	cleanup \
	dmesg \
	fsck \
	getty \
	hostname \
	hwclock \
	kmod-static-nodes \
	loginready \
	locale \
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
	sysctl \
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

TTY_SERVICES = \
	tty1 \
	tty2 \
	tty3 \
	tty4 \
	tty5 \
	tty6

all:
	@echo "Nothing to be done here."

install:
	install -d $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(DATADIR)
	install -d $(DESTDIR)$(SYSCONFDIR)
	install -d $(DESTDIR)$(MANDIR)
	install -d $(DESTDIR)$(DINITDIR)
	install -d $(DESTDIR)$(DINITDIR)/config
	install -d $(DESTDIR)$(DINITDIR)/scripts
	install -d $(DESTDIR)$(DINITDIR)/boot.d
	install -d $(DESTDIR)$(DINITDIR)/mount.d
	install -d $(DESTDIR)$(DINITDIR)/live.d
	install -d $(DESTDIR)$(DINITDIR)/getty.d
	install -d $(DESTDIR)$(LOCALSTATEDIR)/log/dinit
	# placeholder
	touch $(DESTDIR)$(DINITDIR)/mount.d/.KEEP
	touch $(DESTDIR)$(DINITDIR)/boot.d/.KEEP
	touch $(DESTDIR)$(DINITDIR)/live.d/.KEEP
	# config files
	for conf in $(CONF_FILES); do \
		install -m 644 config/$$conf $(DESTDIR)$(DINITDIR)/config; \
	done
	# scripts
	for script in $(SCRIPTS); do \
		install -m 755 scripts/$$script $(DESTDIR)$(DINITDIR)/scripts; \
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
		install -m 644 services/$$srv $(DESTDIR)$(DINITDIR); \
	done
	# getty services
	for srv in $(TTY_SERVICES); do \
		ln -s ../$$srv $(DESTDIR)$(DINITDIR)/getty.d; \
	done
	# misc
	install -Dm644 misc/50-default.conf $(DESTDIR)$(LIBDIR)/sysctl.d/50-default.conf
	install -Dm644 misc/dinit.logrotate $(DESTDIR)$(SYSCONFDIR)/logrotate.d/dinit
