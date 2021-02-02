#!/bin/sh
LIBOPENSMTPD_VERSION=0.5
DKIMSIGN_VERSION=0.3

install_dependencies() {
    apt update
    apt install -y build-essential libbsd-dev bmake curl libssl-dev libevent-dev
}

get_source() {
    curl "https://distfiles.sigtrap.nl/filter-dkimsign-${DKIMSIGN_VERSION}.tar.gz" | tar -zx
    curl "https://distfiles.sigtrap.nl/libopensmtpd-${LIBOPENSMTPD_VERSION}.tar.gz" | tar -zx
}

apply_patch() {
  patch -l "filter-dkimsign-${DKIMSIGN_VERSION}/main.c" main.patch
}

make_libopensmtpd() {
    local MAKE="NEED_OPENBSD_COMPAT=1 NEED_RECALLOCARRAY=1 NEED_STRLCAT=1 NEED_STRLCPY=1 NEED_STRTONUM=1 make -C 'libopensmtpd-${LIBOPENSMTPD_VERSION}' -f Makefile.gnu"
    local INSTALL="install -o root -g root -m 644"
    local INCLUDE_PATH="/usr/include/"

    env -S "$MAKE"
    env -S "$MAKE" install
    $INSTALL "libopensmtpd-${LIBOPENSMTPD_VERSION}/opensmtpd.h" "libopensmtpd-${LIBOPENSMTPD_VERSION}/openbsd-compat/openbsd-compat.h" "${INCLUDE_PATH}"
}

make_dkimsign() {
    local MAKE="bmake -C 'filter-dkimsign-${DKIMSIGN_VERSION}' -f Makefile"

    CFLAGS='-DNEED_RECALLOCARRAY -DNEED_STRLCAT -DNEED_STRLCPY -DNEED_STRTONUM -Wno-pointer-sign' env -S "$MAKE"
    mkdir -p /usr/local/man/man/man8 /usr/local/libexec/smtpd/
    env -S "$MAKE" install
}

install_dependencies
get_source
apply_patch
make_libopensmtpd
make_dkimsign
