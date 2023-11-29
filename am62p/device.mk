
PRODUCT_PACKAGES += audio.primary.am62p

# fstab
ifeq ($(TARGET_SDCARD_BOOT), true)
ifeq ($(TARGET_AVB_ENABLE), true)
PRODUCT_COPY_FILES += \
    device/ti/am62x/am62p/fstab.am62p.avb.sdcard:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.am62p \
    device/ti/am62x/am62p/fstab.am62p.avb.sdcard:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.am62p \
    device/ti/am62x/am62p/fstab.am62p.avb.sdcard:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/etc/fstab.am62p
else
PRODUCT_COPY_FILES += \
    device/ti/am62x/am62p/fstab.am62p.sdcard:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.am62p \
    device/ti/am62x/am62p/fstab.am62p.sdcard:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.am62p \
    device/ti/am62x/am62p/fstab.am62p.sdcard:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/etc/fstab.am62p
endif
else
ifeq ($(TARGET_AVB_ENABLE), true)
PRODUCT_COPY_FILES += \
    device/ti/am62x/am62p/fstab.am62p.avb:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.am62p \
    device/ti/am62x/am62p/fstab.am62p.avb:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.am62p \
    device/ti/am62x/am62p/fstab.am62p.avb:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/etc/fstab.am62p
else
PRODUCT_COPY_FILES += \
    device/ti/am62x/am62p/fstab.am62p:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.am62p \
    device/ti/am62x/am62p/fstab.am62p:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.am62p \
    device/ti/am62x/am62p/fstab.am62p:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/etc/fstab.am62p
endif
endif

# CSI Camera using libcamera
PRODUCT_COPY_FILES += \
     device/ti/am62x/camera/android.hardware.camera.provider@2.5-service_64_am62x.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.camera.provider@2.5-service_64_am62p.rc

# Graphics
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.gralloc=am62p \
    ro.opengles.version=196610

include device/ti/am62x/device-common.mk
