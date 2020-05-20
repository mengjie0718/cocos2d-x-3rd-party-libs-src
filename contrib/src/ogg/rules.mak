# libogg
LIBIOGG_VERSION=1.3.4
LIBIOGG_URL=http://downloads.xiph.org/releases/ogg/libogg-${LIBIOGG_VERSION}.tar.gz

$(TARBALLS)/libogg-$(LIBIOGG_VERSION).tar.gz:
	$(call download,$(LIBIOGG_URL))

.sum-ogg: libogg-$(LIBIOGG_VERSION).tar.gz

ogg: libogg-$(LIBIOGG_VERSION).tar.gz
	$(UNPACK)
.ogg: ogg
	cd lib$<-${LIBIOGG_VERSION} && $(HOSTVARS) ./configure $(HOSTCONF)
	cd lib$<-${LIBIOGG_VERSION} && $(MAKE) install
	touch $@
