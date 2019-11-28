# luajit

LUAJIT_VERSION := 2.1.0-beta3
LUAJIT_URL := http://luajit.org/download/LuaJIT-$(LUAJIT_VERSION).tar.gz

$(TARBALLS)/LuaJIT-$(LUAJIT_VERSION).tar.gz:
	$(call download,$(LUAJIT_URL))

.sum-luajit: LuaJIT-$(LUAJIT_VERSION).tar.gz

luajit: LuaJIT-$(LUAJIT_VERSION).tar.gz .sum-luajit
	$(UNPACK)
ifeq ($(LUAJIT_VERSION),2.0.1)
	$(APPLY) $(SRC)/luajit/v2.0.1_hotfix1.patch
endif

ifeq ($(LUAJIT_VERSION),2.1.0-beta2)
	$(APPLY) $(SRC)/luajit/luajit-v2.1.0-beta2.patch
endif
ifeq ($(LUAJIT_VERSION),2.1.0-beta3)
	$(APPLY) $(SRC)/luajit/luajit-v2.1.0-beta3.patch
endif
	$(MOVE)

ifdef HAVE_IOS
ifeq ($(MY_TARGET_ARCH),armv7)
LUAJIT_HOST_CC="CC -m32 $(OPTIM)"
endif

ifeq ($(MY_TARGET_ARCH),armv7s)
LUAJIT_HOST_CC="gcc -m32 $(OPTIM)"
endif

ifeq ($(MY_TARGET_ARCH),arm64)
LUAJIT_HOST_CC="gcc -m64 $(OPTIM)"
endif

ifeq ($(MY_TARGET_ARCH),i386)
LUAJIT_HOST_CC="gcc -m32 $(OPTIM)"
endif

LUAJIT_TARGET_FLAGS="-isysroot $(IOS_SDK) -Qunused-arguments $(EXTRA_CFLAGS) $(EXTRA_LDFLAGS) $(ENABLE_BITCODE)"
LUAJIT_CROSS_HOST=$(xcrun cc)
endif #endof HAVE_IOS

ifdef HAVE_ANDROID

ifeq ($(MY_TARGET_ARCH),armeabi)
LUAJIT_HOST_CC="gcc -m32 $(OPTIM)"
endif

ifeq ($(MY_TARGET_ARCH),armeabi-v7a)
LUAJIT_HOST_CC="gcc -m32 $(OPTIM)"
endif

ifeq ($(MY_TARGET_ARCH),arm64-v8a)
LUAJIT_HOST_CC="gcc -m64 $(OPTIM)"
endif

ifeq ($(MY_TARGET_ARCH),x86)
LUAJIT_HOST_CC="gcc -m32 $(OPTIM)"
endif

ifeq ($(MY_TARGET_ARCH),x86_64)
LUAJIT_HOST_CC="gcc -m64 $(OPTIM) -DLUAJIT_ENABLE_GC64"
endif

LUAJIT_TARGET_FLAGS="${EXTRA_CFLAGS} ${EXTRA_LDFLAGS}"
LUAJIT_CROSS_HOST=$(HOST)-
endif
ifdef HAVE_WIN32
ifeq ($(MY_TARGET_ARCH),x86_64)
LUAJIT_CROSS_HOST=/sdks/mingw-w64/mingw-w64-x86_64/bin/x86_64-w64-mingw32-
endif
ifeq ($(MY_TARGET_ARCH),i386)
LUAJIT_CROSS_HOST=/sdks/mingw-w64/mingw-w64-i686/bin/i686-w64-mingw32-
endif
endif
.luajit: luajit
ifdef HAVE_ANDROID
	cd $< && $(MAKE) -j8 HOST_CC=$(LUAJIT_HOST_CC) CROSS=$(LUAJIT_CROSS_HOST) CC=clang TARGET_SYS=Linux TARGET_FLAGS=$(LUAJIT_TARGET_FLAGS)
endif

ifdef HAVE_MACOSX
ifeq ($(MY_TARGET_ARCH),x86_64)
	cd $< && CFLAGS="-DLUAJIT_ENABLE_GC64" LD_FLAGS="" $(MAKE) -j8
else
	cd $< && LD_FLAGS="" $(MAKE) -j8
endif
	
endif

ifndef HAVE_ANDROID

ifdef HAVE_LINUX

ifeq ($(MY_TARGET_ARCH),x86_64)
	cd $< && $(HOSTVARS_PIC) $(MAKE) -j8 HOST_CC="$(CC)" HOST_CFLAGS="$(CFLAGS)"
else
	cd $< && $(HOSTVARS_PIC) $(MAKE) -j8 HOST_CC="$(CC) -m32" HOST_CFLAGS="$(CFLAGS)"
endif

endif #ifdef HAVE_LINUX

endif #ifndef HAVE_ANDROID

ifdef HAVE_IOS

ifeq ($(MY_TARGET_ARCH),x86_64)
	cd $< && CFLAGS="-DLUAJIT_ENABLE_GC64" LD_FLAGS="" $(MAKE) -j8
else
	cd $< && $(MAKE) -j8 HOST_CC=$(LUAJIT_HOST_CC) CROSS=$(LUAJIT_CROSS_HOST) TARGET_SYS=iOS  TARGET_FLAGS=$(LUAJIT_TARGET_FLAGS)
endif

endif
ifdef HAVE_WIN32
ifeq ($(MY_TARGET_ARCH),x86_64)
	cd $< && CFLAGS="-DLUAJIT_ENABLE_GC64" LD_FLAGS="" $(MAKE) -j8 CROSS=$(LUAJIT_CROSS_HOST) TARGET_SYS=Windows
else
	cd $< && $(MAKE) -j8 CC="gcc -m32 -O3" CROSS=$(LUAJIT_CROSS_HOST) TARGET_SYS=Windows TARGET_FLAGS=$(LUAJIT_TARGET_FLAGS)
endif
	mkdir -p  $(PREFIX)/lib/
	cd $< && cp src/lua51.dll  $(PREFIX)/lib/
	mkdir -p  $(PREFIX)/bin/
	cd $< && cp src/luajit.exe  $(PREFIX)/bin/
	mkdir -p  $(PREFIX)/include/
endif
ifndef HAVE_WIN32
	cd $< && $(MAKE) install PREFIX=$(PREFIX)
endif
	touch $@
