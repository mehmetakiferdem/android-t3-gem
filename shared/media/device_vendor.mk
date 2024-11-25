PRODUCT_COPY_FILES += \
	frameworks/av/media/libstagefright/data/media_codecs_google_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
	frameworks/av/media/libstagefright/data/media_codecs_google_c2_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_video.xml \
	frameworks/av/media/libstagefright/data/media_codecs_google_c2_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_audio.xml \

# Media configuration
PRODUCT_COPY_FILES += \
	device/ti/am62x/shared/media/config/am62x.media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml

TARGET_PRODUCT_PROP += \
	device/ti/am62x/shared/media/product.prop
