# FFMPEG
FFMPEG_VERSION := 4.3.1
FFMPEG_URL := http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2

configure_option=--prefix=$(PREFIX) --disable-programs --disable-ffmpeg --disable-ffplay --disable-ffprobe --disable-doc --enable-opengl --enable-static --pkg-config-flags="--static" --enable-nonfree
ifdef HAVE_CROSS_COMPILE
	configure_option+=--enable-cross-compile --cross-prefix=$(HOST)- --arch=$(ARCH)
	ifdef HAVE_WIN32
		configure_option+=--target-os=win32
	endif
	ifdef HAVE_IOS
		configure_option+=--target-os=ios
	endif
	ifdef HAVE_ANDROID
		configure_option+=--target-os=android
	endif
endif
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
