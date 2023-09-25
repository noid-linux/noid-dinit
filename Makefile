PREFIX        ?= /usr
SYSCONFDIR    ?= /etc
LOCALSTATEDIR ?= /var
BINDIR        ?= $(PREFIX)/bin
LIBDIR        ?= $(PREFIX)/lib
DATADIR       ?= $(PREFIX)/share
MANDIR        ?= $(DATADIR)/man/man8
DINITSRVDIR   ?= $(LIBDIR)/dinit.d
DINITCNFDIR   ?= $(SYSCONFDIR)/dinit.d

BIN_PROGRAMS = modules-load seedrng

MANPAGES = modules-load.8

CONF_FILES = \
	agetty-default.conf \
	console.conf \
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
	network-pre \
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
	udevd \
	udevd-early \
	udev-settle \
	udev-trigger \
	vconsole


SCRIPTS = \
	agetty \
	agetty-default \
	binfmt \
	cgroup-release-agent.sh \
	cgroups \
	cleanup \
	dmesg \
	hostname \
	hwclock \
	pseudofs \
	udevd \
	vconsole

TTY_SERVICES = \
	tty1 \
	tty2 \
	tty3 \
	tty4 \
	tty5 \
	tty6

LOCALSTATEDIR ?= /var/lib
CFLAGS ?= -O2 -pipe

CFLAGS += -Wall -Wextra -pedantic
CFLAGS += -DLOCALSTATEDIR="\"$(LOCALSTATEDIR)\""

seedrng: bin/seedrng.c
	cc -o bin/seedrng bin/seedrng.c $(CFLAGS)

install:
	install -d $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(LIBDIR)
	install -d $(DESTDIR)$(DATADIR)
	install -d $(DESTDIR)$(SYSCONFDIR)
	install -d $(DESTDIR)$(MANDIR)
	install -d $(DESTDIR)$(DINITSRVDIR)
	install -d $(DESTDIR)$(DINITCNFDIR)/config
	install -d $(DESTDIR)$(LIBDIR)/dinit
	install -d $(DESTDIR)$(DINITCNFDIR)/boot.d
	install -d $(DESTDIR)$(DINITCNFDIR)/mount.d
	install -d $(DESTDIR)$(DINITCNFDIR)/live.d
	install -d $(DESTDIR)$(LOCALSTATEDIR)/log/dinit
	# placeholder
	touch $(DESTDIR)$(DINITCNFDIR)/mount.d/.KEEP
	touch $(DESTDIR)$(DINITCNFDIR)/boot.d/.KEEP
	touch $(DESTDIR)$(DINITCNFDIR)/live.d/.KEEP
	# config files
	for conf in $(CONF_FILES); do \
		install -m 644 config/$$conf $(DESTDIR)$(DINITCNFDIR)/config; \
	done
	# scripts
	for script in $(SCRIPTS); do \
		install -m 755 scripts/$$script $(DESTDIR)$(LIBDIR)/dinit; \
	done
	# programs
	for prog in $(BIN_PROGRAMS); do \
		install -m 755 bin/$$prog $(DESTDIR)$(LIBDIR)/dinit; \
	done
	# manpages
	for man in $(MANPAGES); do \
		install -m 644 man/$$man $(DESTDIR)$(MANDIR); \
	done
	# services
	for srv in $(SERVICES); do \
		install -m 644 services/$$srv $(DESTDIR)$(DINITSRVDIR); \
	done
	# getty services
	for srv in $(TTY_SERVICES); do \
		install -m 644 services/$$srv $(DESTDIR)$(DINITCNFDIR); \
	done
	# misc
	install -Dm644 misc/50-default.conf $(DESTDIR)$(LIBDIR)/sysctl.d/50-default.conf
	install -Dm644 misc/dinit.logrotate $(DESTDIR)$(SYSCONFDIR)/logrotate.d/dinit

clean:
	rm -f bin/seedrng

.PHONY: clean
