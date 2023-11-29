PRODUCT_PLATFORM := am62p

# Graphics
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196610

# Force GPU for composition instead of HW Composer
PRODUCT_VENDOR_PROPERTIES += \
    vendor.hwc.drm.scale_with_gpu=1

include device/ti/am62x/device-common.mk
