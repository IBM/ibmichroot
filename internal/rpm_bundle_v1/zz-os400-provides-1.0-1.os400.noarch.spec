#
# rpmbuild -ba --target=noarch zz-os400-provides-1.0-1.os400.noarch.spec
#
Summary: Creates provides for IBM i
Name: zz-os400-provides
Version: 1.0
Release: 1
License: MIT
URL: http://yips.idevcloud.com/
Group: System Environment/Base
BuildRoot: /var/tmp/zz-os400-provides

provides: rpm = 4.9.1.3
provides: AIX-rpm
provides: bash
provides: /bin/sh
provides: /usr/bin/env
provides: /usr/bin/ksh
provides: /bin/ksh
provides: /sbin/install-info
provides: libbsd.a(shr.o)
provides: libbz2.a(libbz2.so.1)
provides: libc.a(shr.o)
provides: libcrypt.a(shr.o)
provides: libcrypto.a(libcrypto.so)
provides: libcurses.a(shr42.o)
provides: libiconv.a(shr4.o)
provides: libnsl.a(shr.o)
provides: libpthread.a(shr_xpg5.o)
provides: libpthreads.a(shr_comm.o)
provides: libpthreads.a(shr_xpg5.o)
provides: librtl.a(shr.o)
provides: libssl.a(libssl.so)
provides: libz.a(libz.so.1)
provides: libnss3.so
provides: libpopt.so
provides: librpm.so
provides: librpmbuild.so
provides: librpmio.so
provides: librpmsign.so
provides: libtcl8.4.so
provides: libtk8.4.so

%description
Creates provides for IBM i

%build

%clean

%install
rm -r /var/tmp/*
mkdir -p /var/tmp/zz-os400-provides.ppc

%files

