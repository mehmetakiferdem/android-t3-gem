# Enable USB Camera
PRODUCT_COPY_FILES += \
	device/ti/am62x/shared/camera/config/external_camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/external_camera_config.xml \
	device/ti/am62x/shared/camera/config/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

PRODUCT_COPY_FILES +=  \
	frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
	frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
	frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml

# CSI Camera using libcamera
PRODUCT_COPY_FILES += \
	device/ti/am62x/shared/camera/config/camera_hal.yaml:$(TARGET_COPY_OUT_VENDOR)/etc/libcamera/camera_hal.yaml

PRODUCT_PACKAGES_DEBUG += cam

PRODUCT_PACKAGES += \
	camera.libcamera

TARGET_PRODUCT_PROP += \
	device/ti/am62x/shared/camera/product.prop

PRODUCT_COPY_FILES += \
	device/ti/am62x/shared/camera/config/android.hardware.camera.provider@2.5-service_64_am62x.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.camera.provider@2.5-service_64_$(PRODUCT_PLATFORM).rc

# Camera
PRODUCT_PACKAGES += \
	android.hardware.camera.provider@2.5-service_64

# Enable USB Camera
PRODUCT_PACKAGES += \
	android.hardware.camera.provider@2.5-external-service_64.ti
