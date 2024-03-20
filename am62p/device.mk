PRODUCT_PLATFORM := am62p

# Graphics
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196610

# Force GPU for composition instead of HW Composer
PRODUCT_VENDOR_PROPERTIES += \
    vendor.hwc.drm.scale_with_gpu=1

# Ueventd
PRODUCT_COPY_FILES += \
    device/ti/am62x/am62p/ueventd.am62p.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc

include device/ti/am62x/device-common.mk
