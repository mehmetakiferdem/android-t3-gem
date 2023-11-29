
PRODUCT_PACKAGES += audio.primary.am62x

# CSI Camera using libcamera
PRODUCT_COPY_FILES += \
     device/ti/am62x/camera/android.hardware.camera.provider@2.5-service_64_am62x.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.camera.provider@2.5-service_64_am62x.rc

# Graphics
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.gralloc=am62x \
    ro.opengles.version=196609

include device/ti/am62x/device-common.mk
