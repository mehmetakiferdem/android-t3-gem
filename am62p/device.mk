PRODUCT_PLATFORM := am62p

# Graphics
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196610

# Force GPU for composition instead of HW Composer
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.hwc.drm.scale_with_gpu=1

include device/ti/am62x/device-common.mk
