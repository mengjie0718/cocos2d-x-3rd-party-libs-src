# FFMPEG
FFMPEG_VERSION := 4.3.1
FFMPEG_URL := http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2

configure_option=--prefix=$(PREFIX) --disable-programs --disable-doc --enable-opengl --enable-static --pkg-config-flags="--static" --enable-nonfree

$(TARBALLS)/ffmpeg-${FFMPEG_VERSION}.tar.bz2:
	$(call download,$(FFMPEG_URL))

.sum-ffmpeg: ffmpeg-${FFMPEG_VERSION}.tar.bz2

ffmpeg: ffmpeg-${FFMPEG_VERSION}.tar.bz2 .sum-ffmpeg
	$(UNPACK)
	$(MOVE)
.ffmpeg: ffmpeg
	cd $< && GNUMAKE=$(MAKE) $(HOSTVARS) ./configure ${configure_option}
	cd $< && $(MAKE) -j4 && $(MAKE) install
	touch $@
