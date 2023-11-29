
PRODUCT_PACKAGES += audio.primary.am62x

# fstab
ifeq ($(TARGET_SDCARD_BOOT), true)
ifeq ($(TARGET_AVB_ENABLE), true)
PRODUCT_COPY_FILES += \
    device/ti/am62x/am62x/fstab.am62x.avb.sdcard:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.am62x \
    device/ti/am62x/am62x/fstab.am62x.avb.sdcard:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.am62x \
    device/ti/am62x/am62x/fstab.am62x.avb.sdcard:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/etc/fstab.am62x
else
PRODUCT_COPY_FILES += \
    device/ti/am62x/am62x/fstab.am62x.sdcard:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.am62x \
    device/ti/am62x/am62x/fstab.am62x.sdcard:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.am62x \
    device/ti/am62x/am62x/fstab.am62x.sdcard:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/etc/fstab.am62x
endif
else
ifeq ($(TARGET_AVB_ENABLE), true)
PRODUCT_COPY_FILES += \
    device/ti/am62x/am62x/fstab.am62x.avb:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.am62x \
    device/ti/am62x/am62x/fstab.am62x.avb:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.am62x \
    device/ti/am62x/am62x/fstab.am62x.avb:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/etc/fstab.am62x
else
PRODUCT_COPY_FILES += \
    device/ti/am62x/am62x/fstab.am62x:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.am62x \
    device/ti/am62x/am62x/fstab.am62x:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.am62x \
    device/ti/am62x/am62x/fstab.am62x:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/etc/fstab.am62x
endif
endif

# CSI Camera using libcamera
PRODUCT_COPY_FILES += \
     device/ti/am62x/camera/android.hardware.camera.provider@2.5-service_64_am62x.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.camera.provider@2.5-service_64_am62x.rc

# Graphics
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.gralloc=am62x \
    ro.opengles.version=196609

include device/ti/am62x/device-common.mk
