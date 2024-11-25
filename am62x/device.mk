
PRODUCT_PLATFORM := am62x

# Graphics
PRODUCT_VENDOR_PROPERTIES += \
	ro.opengles.version=196609

# Ueventd
PRODUCT_COPY_FILES += \
	device/ti/am62x/am62x/ueventd.am62x.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \
	device/ti/am62x/shared/camera/config/android.hardware.camera.provider@2.5-service_am62x.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.camera.provider@2.5-service_$(PRODUCT_PLATFORM).rc \

# Camera
PRODUCT_PACKAGES += \
	android.hardware.camera.provider@2.5-service

# Enable USB Camera
PRODUCT_PACKAGES += android.hardware.camera.provider@2.5-external-service.ti

include device/ti/am62x/device-common.mk
