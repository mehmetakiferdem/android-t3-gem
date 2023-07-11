
# Copyright 2022 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
PRODUCT_SOONG_NAMESPACES += device/ti/am62x/

# AVB
ifeq ($(TARGET_BUILD_VARIANT), user)
TARGET_AVB_ENABLE := true
endif

# Kernel part
LOCAL_KERNEL := device/ti/am62x-kernel/kernel/$(TARGET_KERNEL_USE)/Image.lz4
LOCAL_DTB := device/ti/am62x-kernel/kernel/$(TARGET_KERNEL_USE)

PRODUCT_COPY_FILES += \
        $(LOCAL_KERNEL):kernel

# Build and run only ART
PRODUCT_RUNTIMES := runtime_libart_default
# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/retrofit.mk)

$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)
DEVICE_PACKAGE_OVERLAYS := device/ti/am62x/overlay

# Installs gsi keys into ramdisk, to boot a developer GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)

# Set Vendor SPL to match platform
VENDOR_SECURITY_PATCH = $(PLATFORM_SECURITY_PATCH)
# Set boot SPL
BOOT_SECURITY_PATCH = $(PLATFORM_SECURITY_PATCH)

# Dynamic partitions
PRODUCT_BUILD_SUPER_PARTITION := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_USE_DYNAMIC_PARTITION_SIZE := true

# Set default log size to 1M
PRODUCT_PROPERTY_OVERRIDES += \
  ro.logd.size=1M

#enforce permission allowlists for system apps.
PRODUCT_PROPERTY_OVERRIDES += \
  ro.control_privapp_permissions=enforce

# disable 64-bit dex2oat to save memory.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat64.enabled=false

# Enable Incremental on the device
PRODUCT_PROPERTY_OVERRIDES += \
	ro.incremental.enable=true

# Enable zygote critical window.
PRODUCT_PROPERTY_OVERRIDES += \
	zygote.critical_window.minute=10


PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml

# Add wifi-related packages
PRODUCT_PACKAGES += libwpa_client wpa_supplicant hostapd wificond wpa_cli
PRODUCT_PROPERTY_OVERRIDES += wifi.interface=wlan0 \
                              wifi.supplicant_scan_interval=15

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \

# Wifi configuration files
PRODUCT_COPY_FILES += \
    device/ti/am62x/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
    device/ti/am62x/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
    device/ti/am62x/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf

PRODUCT_PACKAGES += \
	android.hardware.fastboot@1.1 \
	android.hardware.fastboot@1.1-impl-mock \
	fastbootd

# Set lowram options and enable traced by default
PRODUCT_VENDOR_PROPERTIES += \
     ro.config.low_ram=true


# Speed profile services and wifi-service to reduce RAM and storage.
PRODUCT_SYSTEM_SERVER_COMPILER_FILTER := speed-profile

# A/B support
PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_engine_sideload \
    update_verifier \
    sg_write_buffer \
    f2fs_io \
    check_f2fs

# The following modules are included in debuggable builds only.
PRODUCT_PACKAGES_DEBUG += \
    bootctl \
    update_engine_client \
    SystemUpdaterSample

# Userdata Checkpointing OTA GC
PRODUCT_PACKAGES += \
	checkpoint_gc

# Boot control
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-impl.recovery \
    android.hardware.boot@1.2-service \
    bootctrl.default

ifeq ($(TARGET_AVB_ENABLE), true)
#copy xml file to tell PackageManager that the system supports Verified Boot
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:system/etc/permissions/android.software.verified_boot.xml
endif # eq $(TARGET_AVB_ENABLE), true

PRODUCT_SHIPPING_API_LEVEL := 33
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false
# Enforce the Product interface
PRODUCT_PRODUCT_VNDK_VERSION := current

# Power HAL
PRODUCT_PACKAGES += android.hardware.power-service.example

# Health: Install default binderized implementation to vendor.
PRODUCT_PACKAGES += \
    android.hardware.health-service.cuttlefish \
    android.hardware.health-service.cuttlefish_recovery

# Health Storage
PRODUCT_PACKAGES += \
    android.hardware.health.storage-service.cuttlefish

# Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.4-service

PRODUCT_PACKAGES += \
    hwcomposer.drm

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.gralloc=am62x \
    ro.hardware.hwcomposer=drm \
    ro.hardware.egl=powervr \
    ro.hardware.vulkan=powervr

PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196609

PRODUCT_PROPERTY_OVERRIDES += \
    vendor.hwc.drm.device=/dev/dri/card0

# Public Libraries
PRODUCT_COPY_FILES += \
    device/ti/am62x/public.libraries.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt

# Vulkan
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
	frameworks/native/data/etc/android.software.vulkan.deqp.level-2021-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml \
	frameworks/native/data/etc/android.software.opengles.deqp.level-2021-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml

# Audio:
# NOTE: each product should also add audio.primary.$(TARGET_DEVICE) to its PRODUCT_PACKAGES
PRODUCT_PACKAGES += \
    audio.r_submix.default \
    android.hardware.audio.service \
    android.hardware.audio@6.0-impl \
    android.hardware.audio.effect@6.0-impl

PRODUCT_PACKAGES += audio.primary.am62x

# Audio USB HAL
PRODUCT_PACKAGES += \
    audio.usb.default

# audio policy configuration
USE_XML_AUDIO_POLICY_CONF := 1
PRODUCT_COPY_FILES += \
    device/ti/am62x/audio_hal_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.am62x.xml \
    device/ti/am62x/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/media/libeffects/data/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml

# Low level audio tools for debugging
PRODUCT_PACKAGES_DEBUG += \
    tinyplay \
    tinycap \
    tinymix \
    tinypcminfo \
    cplay

# USB HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.2-service.generic

PRODUCT_COPY_FILES += \
    hardware/ti/am62x/usb/1.2/init.gadgethal.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.gadgethal.sh

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml


PRODUCT_PACKAGES += android.hardware.drm@latest-service.clearkey

# Thermal
PRODUCT_PACKAGES += \
        android.hardware.thermal@2.0-service.ti

# Copy hardware config file(s)
PRODUCT_COPY_FILES += \
        device/linaro/hikey/etc/permissions/android.hardware.screen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.xml \
        device/ti/am62x/android.software.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.xml \
        frameworks/native/data/etc/android.software.cts.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.cts.xml \
        frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
        frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
        frameworks/native/data/etc/android.software.voice_recognizers.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.voice_recognizers.xml \
        frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
        frameworks/native/data/etc/android.software.device_admin.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_admin.xml \
        device/ti/am62x/android.hardware.hardware_keystore.optee-keymaster.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.hardware_keystore.optee-keymaster.xml \
        frameworks/native/data/etc/android.software.secure_lock_screen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.secure_lock_screen.xml

PRODUCT_COPY_FILES += \
        device/ti/am62x/init.am62x.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.am62x.rc \
        device/ti/am62x/init.am62x.zygote_wakelock.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.am62x.zygote_wakelock.rc \
        device/ti/am62x/init.am62x.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.am62x.usb.rc \
        device/ti/am62x/ueventd.am62x.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc

# fstab
ifeq ($(TARGET_SDCARD_BOOT), true)
ifeq ($(TARGET_AVB_ENABLE), true)
PRODUCT_COPY_FILES += \
    device/ti/am62x/fstab.am62x.avb.sdcard:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.am62x \
    device/ti/am62x/fstab.am62x.avb.sdcard:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.am62x
else
PRODUCT_COPY_FILES += \
    device/ti/am62x/fstab.am62x.sdcard:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.am62x \
    device/ti/am62x/fstab.am62x.sdcard:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.am62x
endif
else
ifeq ($(TARGET_AVB_ENABLE), true)
PRODUCT_COPY_FILES += \
    device/ti/am62x/fstab.am62x.avb:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.am62x \
    device/ti/am62x/fstab.am62x.avb:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.am62x
else
PRODUCT_COPY_FILES += \
    device/ti/am62x/fstab.am62x:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.am62x \
    device/ti/am62x/fstab.am62x:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.am62x
endif
endif
# RecoveryOS
PRODUCT_COPY_FILES += \
    device/ti/am62x/init.recovery.am62x.rc:recovery/root/vendor/etc/init/init.recovery.am62x.rc

# Media
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_audio.xml \

# Media configuration
PRODUCT_COPY_FILES += \
        device/ti/am62x/am62x.media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml

# Memtrack
PRODUCT_PACKAGES += \
        android.hardware.memtrack-service.example

# Dumpstate
PRODUCT_PACKAGES += \
        android.hardware.dumpstate-service.example

# Atrace
PRODUCT_PACKAGES += \
        android.hardware.atrace@1.0-service

# Enable USB Camera
PRODUCT_PACKAGES += android.hardware.camera.provider@2.5-external-service
PRODUCT_COPY_FILES += \
    device/ti/am62x/camera/external_camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/external_camera_config.xml

PRODUCT_COPY_FILES +=  \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml

# CSI Camera using libcamera
PRODUCT_COPY_FILES += \
     device/ti/am62x/camera/camera_hal.yaml:$(TARGET_COPY_OUT_VENDOR)/etc/libcamera/camera_hal.yaml \
     device/ti/am62x/camera/android.hardware.camera.provider@2.5-service_64_am62x.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.camera.provider@2.5-service_64_am62x.rc

PRODUCT_PACKAGES_DEBUG += cam

PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.5-service_64 \
    camera.libcamera

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.camera=libcamera

PRODUCT_PACKAGES += \
        Launcher3QuickStep \
        WallpaperPicker

#
# Enable bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.1-service.btlinux

# Bluetooth se policies
BOARD_SEPOLICY_DIRS += system/bt/vendor_libs/linux/sepolicy
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml

# Demo apps
PRODUCT_PACKAGES_DEBUG += cabin_demo

# Include hardware projects (HALs)
$(call inherit-product-if-exists, hardware/ti/am62x/am62x.mk)

# Include vendor binaries
$(call inherit-product-if-exists, vendor/ti/am62x/am62x.mk)
