# FFMPEG
FFMPEG_VERSION := 4.3.1
FFMPEG_URL := http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2

FFMPEG_OPTION=--prefix=$(PREFIX) --disable-securetransport --disable-encoders \
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
--disable-indevs \
--disable-parsers --disable-decoders --enable-decoder=h264 --enable-decoder=mpeg4 --enable-parser=h264 --enable-parser=mpeg4video --enable-parser=mpegvideo \
--enable-protocol=file --disable-filters \
--disable-demuxers --enable-demuxer=aac --enable-demuxer=concat \
--enable-demuxer=data --enable-demuxer=hls \
--enable-demuxer=mov --enable-demuxer=mpegps \
--enable-demuxer=mpegts
ifdef HAVE_CROSS_COMPILE
	FFMPEG_OPTION+=--enable-cross-compile
	ifdef HAVE_WIN32
		FFMPEG_OPTION+=--arch=$(MY_TARGET_ARCH) --target-os=mingw32 --enable-shared --cross-prefix=$(HOST)- 
	endif
	ifdef HAVE_IOS
		FFMPEG_OPTION+=--arch=$(MY_TARGET_ARCH) --target-os=darwin --enable-static
	endif
	ifdef HAVE_ANDROID
		ifeq ($(MY_TARGET_ARCH),arm64-v8a)
			FFMPEG_OPTION+=--arch=aarch64
		else
			FFMPEG_OPTION+=--arch=$(MY_TARGET_ARCH)
		endif
		FFMPEG_OPTION+=--target-os=android --disable-shared --enable-static \
		 --extra-cflags="-Os -fPIC -DANDROID -Wfatal-errors -Wno-deprecated" \
         --extra-cxxflags="-D__thumb__ -fexceptions -frtti"
	endif
endif
$(TARBALLS)/ffmpeg-${FFMPEG_VERSION}.tar.bz2:
	$(call download,$(FFMPEG_URL))

.sum-ffmpeg: ffmpeg-${FFMPEG_VERSION}.tar.bz2

ffmpeg: ffmpeg-${FFMPEG_VERSION}.tar.bz2 .sum-ffmpeg
	$(UNPACK)
	$(MOVE)
.ffmpeg: ffmpeg
	cd $< && GNUMAKE=$(MAKE) $(HOSTVARS) ./configure ${FFMPEG_OPTION}
	cd $< && $(MAKE) -j4 && $(MAKE) install
	touch $@
