
PRODUCT_PACKAGES += audio.primary.am62p

# CSI Camera using libcamera
PRODUCT_COPY_FILES += \
     device/ti/am62x/camera/android.hardware.camera.provider@2.5-service_64_am62x.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.camera.provider@2.5-service_64_am62p.rc

# Graphics
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.gralloc=am62p \
    ro.opengles.version=196610

# Force GPU for composition instead of HW Composer
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.hwc.drm.scale_with_gpu=1

include device/ti/am62x/device-common.mk
