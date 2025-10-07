GRALLOC_PLATFORM := am62p

# Graphics
PRODUCT_VENDOR_PROPERTIES += \
	ro.opengles.version=196610

# Force GPU for composition instead of HW Composer
PRODUCT_VENDOR_PROPERTIES += \
	vendor.hwc.drm.scale_with_gpu=1

# Ueventd
PRODUCT_COPY_FILES += \
	device/ti/am62x/am62p/ueventd.am62p.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc

# V4L2 Codec2
PRODUCT_SOONG_NAMESPACES += external/v4l2_codec2

PRODUCT_COPY_FILES += \
	device/ti/am62x/am62p/android.hardware.media.c2-extended-seccomp_policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/android.hardware.media.c2-extended-seccomp_policy \
	device/ti/am62x/am62p/media_codecs_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_c2.xml

# Set the customized property of v4l2_codec2, including:
# - The maximum concurrent instances for decoder/encoder.
#   It should be the same as "concurrent-instances" at media_codec_c2.xml.
PRODUCT_VENDOR_PROPERTIES += \
	ro.vendor.v4l2_codec2.decode_concurrent_instances=32

PRODUCT_PACKAGES += \
	android.hardware.media.c2@1.2-service-v4l2 \
	libc2plugin_store

# See:
# https://android.googlesource.com/platform/external/v4l2_codec2/#quick-start-guide
# for documentation on the bitmask values
PRODUCT_VENDOR_PROPERTIES += \
	debug.stagefright.c2-poolmask=0x1f50000

include device/ti/am62x/device-common.mk
