# FFMPEG
FFMPEG_VERSION := 4.3.1
FFMPEG_URL := http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2

configure_option=--prefix=$(PREFIX) --disable-securetransport --disable-encoders \
--disable-coreimage   \
--disable-bzlib \
--disable-programs \
--disable-ffmpeg \
--disable-ffplay \
--disable-network --disable-protocols --disable-protocol=rtp --disable-protocol=udp --disable-protocol=http --disable-protocol=tcp \
--disable-ffprobe \
--disable-doc \
--disable-opengl  \
--disable-muxers \
--disable-bsfs \
--disable-parsers --disable-decoders --enable-decoder=h264 --enable-decoder=mpeg4 --enable-parser=h264 --enable-parser=mpeg4video --enable-parser=mpegvideo \
--enable-protocol=file
ifdef HAVE_CROSS_COMPILE
	configure_option+=--enable-cross-compile --arch=$(MY_TARGET_ARCH)
	ifdef HAVE_WIN32
		configure_option+=--target-os=mingw32 --enable-shared --cross-prefix=$(HOST)- 
	endif
	ifdef HAVE_IOS
		configure_option+=--target-os=darwin
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
