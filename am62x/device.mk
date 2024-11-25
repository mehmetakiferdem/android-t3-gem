
PRODUCT_PLATFORM := am62x

# Graphics
PRODUCT_VENDOR_PROPERTIES += \
	ro.opengles.version=196609

# Ueventd
PRODUCT_COPY_FILES += \
	device/ti/am62x/am62x/ueventd.am62x.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc

include device/ti/am62x/device-common.mk
