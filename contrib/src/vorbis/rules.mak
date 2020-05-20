# libvorbis
LIBVORBIS_VERSION=1.3.6
LIBVORBIS_URL=http://downloads.xiph.org/releases/vorbis/libvorbis-${LIBVORBIS_VERSION}.tar.xz

$(TARBALLS)/libvorbis-$(LIBVORBIS_VERSION).tar.gz:
	$(call download,$(LIBVORBIS_URL))

.sum-vorbis: libvorbis-$(LIBVORBIS_VERSION).tar.gz

vorbis: libvorbis-$(LIBVORBIS_VERSION).tar.gz
	$(UNPACK)
.vorbis: vorbis toolchain.cmake
	cd lib$<-${LIBVORBIS_VERSION} && $(HOSTVARS) CFLAGS="$(CFLAGS) $(EX_ECFLAGS)" ./configure --host=${HOST} --prefix=$(PREFIX)
	cd lib$<-${LIBVORBIS_VERSION} && $(MAKE) install
	touch $@
