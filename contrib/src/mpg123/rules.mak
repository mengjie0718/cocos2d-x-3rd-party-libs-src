# libmpg123
LIBMPG123_VERSION=1.26rc3
LIBMPG123_URL=http://www.mpg123.de/download/mpg123-${LIBMPG123_VERSION}.tar.bz2

$(TARBALLS)/mpg123-$(LIBMPG123_VERSION).tar.bz2:
	$(call download,$(LIBMPG123_URL))

.sum-mpg123: mpg123-$(LIBMPG123_VERSION).tar.bz2

mpg123: mpg123-$(LIBMPG123_VERSION).tar.bz2
	$(UNPACK)
.mpg123: mpg123 
	cd $<-${LIBMPG123_VERSION} && $(HOSTVARS) ./configure $(HOSTCONF)
	cd $<-${LIBMPG123_VERSION} && $(MAKE) install
	touch $@
