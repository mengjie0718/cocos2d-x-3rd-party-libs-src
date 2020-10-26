# OPENAL
OPENAL_VERSION := 1.20.1
OPENAL_URL := https://www.openal-soft.org/openal-releases/openal-soft-${OPENAL_VERSION}.tar.bz2

$(TARBALLS)/openal-soft-${OPENAL_VERSION}.tar.bz2:
	$(call download,$(OPENAL_URL))

.sum-openal: openal-soft-${OPENAL_VERSION}.tar.bz2

openal: openal-soft-${OPENAL_VERSION}.tar.bz2 .sum-glfw
	$(UNPACK)
	$(MOVE)

.openal: openal toolchain.cmake
	cd $< && $(HOSTVARS) CFLAGS="$(CFLAGS) $(EX_ECFLAGS)" ${CMAKE} . -DLIBTYPE=STATIC -DALSOFT_STATIC_WINPTHREAD=1 -DALSOFT_UTILS=0 -DALSOFT_EXAMPLES=0 -DALSOFT_TESTS=0 -DCMAKE_INSTALL_PREFIX=$(PREFIX)
	cd $< && $(MAKE) VERBOSE=1 install
	touch $@
