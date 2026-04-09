CC            ?= cc
PREFIX        ?= /usr
SYSCONFDIR    ?= /etc
LOCALSTATEDIR ?= /var
BINDIR        ?= $(PREFIX)/bin
LIBDIR        ?= $(PREFIX)/lib
DATADIR       ?= $(PREFIX)/share
MANDIR        ?= $(DATADIR)/man
DINITSRVDIR   ?= $(LIBDIR)/dinit.d
DINITCNFDIR   ?= $(SYSCONFDIR)/dinit.d
SEEDRNGDIR    ?= $(LOCALSTATEDIR)/lib

BIN_PROGRAMS = modules-load dbus-wait-for seedrng

MAN5 = locale.conf.5 vconsole.conf.5
MAN8 = modules-load.8

CONF_FILES = \
	console.conf \
	agetty-default.conf \
	network-online.conf

SERVICEDIR = boot.d

SERVICES = \
	agetty \
	boot \
	cleanup \
	dmesg \
	fsck \
	fsck-root \
	getty \
	hostname \
	hwclock \
	kmod-static-nodes \
	locale \
	modules \
	net-lo \
	network \
	network-pre \
	pseudofs \
	random-seed \
	recovery \
	root-ro \
	single \
	swap \
	sysctl \
	system \
	tmpfs \
	udevd \
	udevd-early \
	udev-settle \
	udev-trigger

TARGETS = \
	early-console.target \
	early-devices.target \
	early-fs-fstab.target \
	early-fs-local.target \
	early-fs-pre.target \
	early-keyboard.target \
	early-modules.target \
	early-prepare.target \
	early-root-rw.target \
	local.target \
	login.target \
	network.target \
	network-online.target \
	pre-local.target \
	pre-network.target \
	time-sync.target

SCRIPTS = \
	agetty \
	agetty-default \
	cleanup \
	dmesg \
	fsck \
	hostname \
	hwclock \
	locale \
	net-online \
	pseudofs \
	rclocal \
	udevd \
	udev-trigger \
	vconsole

TTY_SERVICES = \
	getty@tty1 \
	getty@tty2 \
	getty@tty3 \
	getty@tty4 \
	getty@tty5 \
	getty@tty6

CFLAGS ?= -O2 -pipe

CFLAGS += -Wall -Wextra -pedantic

all: bin man

bin/dbus-wait-for: bin/dbus-wait-for.c
	$(CC) -o bin/dbus-wait-for bin/dbus-wait-for.c $(CFLAGS) `pkg-config --libs --cflags dbus-1`

bin/seedrng: bin/seedrng.c
	$(CC) -o bin/seedrng bin/seedrng.c $(CFLAGS) -DLOCALSTATEDIR="\"$(SEEDRNGDIR)\""

bin: bin/dbus-wait-for bin/seedrng

# there has to be a better way
man/modules-load.8: man/modules-load.8.scd
	scdoc < $< > $@

man/locale.conf.5: man/locale.conf.5.scd
	scdoc < $< > $@

man/vconsole.conf.5: man/vconsole.conf.5.scd
	scdoc < $< > $@

man: man/locale.conf.5 man/vconsole.conf.5 man/modules-load.8

install:
	install -d $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(LIBDIR)
	install -d $(DESTDIR)$(DATADIR)
	install -d $(DESTDIR)$(SYSCONFDIR)
	install -d $(DESTDIR)$(MANDIR)
	install -d $(DESTDIR)$(DINITSRVDIR)
	install -d $(DESTDIR)$(DINITCNFDIR)/config
	install -d $(DESTDIR)$(LIBDIR)/dinit
	install -d $(DESTDIR)$(DINITSRVDIR)/boot.d
	install -d $(DESTDIR)$(DINITCNFDIR)/boot.d
	install -d $(DESTDIR)$(LOCALSTATEDIR)/log/dinit
	# placeholder
	touch $(DESTDIR)$(DINITCNFDIR)/boot.d/.KEEP
	# config files
	install -m 644 config/hwclock.conf $(DESTDIR)$(SYSCONFDIR)/hwclock.conf; \
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
	for man in $(MAN5); do \
		install -Dm644 man/$$man $(DESTDIR)$(MANDIR)/man5/$$man; \
	done
	for man in $(MAN8); do \
		install -Dm644 man/$$man $(DESTDIR)$(MANDIR)/man8/$$man; \
	done
	# services
	for srv in $(SERVICES); do \
		install -m 644 services/$$srv $(DESTDIR)$(DINITSRVDIR); \
	done
	# targets
	for srv in $(TARGETS); do \
		install -m 644 services/$$srv $(DESTDIR)$(DINITSRVDIR); \
	done
	# getty services
	for srv in $(TTY_SERVICES); do \
		sed "s|@DINITSRVDIR[@]|$(DINITSRVDIR)|g" services/$$srv.in > $(DESTDIR)$(DINITCNFDIR)/$$srv; \
		chmod 644 $(DESTDIR)$(DINITCNFDIR)/$$srv; \
	done
	# install default service
	ln -sf ../agetty $(DESTDIR)$(DINITSRVDIR)/boot.d/agetty
	ln -sf ../udevd $(DESTDIR)$(DINITSRVDIR)/boot.d/udevd
	# shutdown hook
	install -Dm755 misc/shutdown-hook $(DESTDIR)$(LIBDIR)/dinit/shutdown-hook
	# misc
	install -Dm755 misc/01-dinit-env.sh $(DESTDIR)$(SYSCONFDIR)/X11/xinit/xinitrc.d/01-dinit-env.sh
	install -Dm644 misc/50-default.conf $(DESTDIR)$(LIBDIR)/sysctl.d/50-default.conf
	install -Dm644 misc/dinit.logrotate $(DESTDIR)$(SYSCONFDIR)/logrotate.d/dinit
	install -Dm644 misc/dinit-rc.tmpfiles $(DESTDIR)$(LIBDIR)/tmpfiles.d/dinit-rc.conf

clean:
	rm -f bin/seedrng
	rm -f bin/dbus-wait-for
	rm -f man/*.8
	rm -f man/*.5

.PHONY: all clean
