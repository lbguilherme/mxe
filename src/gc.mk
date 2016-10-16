# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.6.0
$(PKG)_CHECKSUM := a14a28b1129be90e55cd6f71127ffc5594e1091d5d54131528c24cd0c03b7d90
$(PKG)_SUBDIR   := $(PKG)-7.6.0
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://hboehm.info/$(PKG)/$(PKG)_source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libatomic_ops

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hboehm.info/gc/gc_source/' | \
    grep '<a href="gc-' | \
    $(SED) -n 's,.*<a href="gc-\([0-9][^"]*\)\.tar.*,\1,p' | \
    grep -v 'alpha' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --enable-threads=win32 \
        --enable-cplusplus
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
