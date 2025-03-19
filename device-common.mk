
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

# Kernel part
LOCAL_KERNEL := device/ti/am62x-kernel/kernel/$(TARGET_KERNEL_USE)/Image.lz4
LOCAL_DTB := device/ti/am62x-kernel/kernel/$(TARGET_KERNEL_USE)

PRODUCT_COPY_FILES += \
	$(LOCAL_KERNEL):kernel

# Build and run only ART
PRODUCT_RUNTIMES := runtime_libart_default
# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Use generic ramdisk (init_boot)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/android_t_baseline.mk)
PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4

$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

# pKVM
$(call inherit-product-if-exists, packages/modules/Virtualization/apex/product_packages.mk)

# Overlays
PRODUCT_PACKAGES += \
	AndroidAM62Overlay \
	SettingsProviderAM62Overlay

# Installs gsi keys into ramdisk, to boot a developer GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)

# Set Vendor SPL to match platform
VENDOR_SECURITY_PATCH = $(PLATFORM_SECURITY_PATCH)
# Set boot SPL
BOOT_SECURITY_PATCH = $(PLATFORM_SECURITY_PATCH)

# fstab
PRODUCT_PACKAGES += \
	fstab.am62.sdcard.avb \
	fstab.am62.sdcard.avb.vendor_ramdisk \
	fstab.am62.sdcard \
	fstab.am62.sdcard.vendor_ramdisk \
	fstab.am62.mmc.avb \
	fstab.am62.mmc.avb.vendor_ramdisk \
	fstab.am62.mmc \
	fstab.am62.mmc.vendor_ramdisk

# Dynamic partitions
PRODUCT_BUILD_SUPER_PARTITION := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_USE_DYNAMIC_PARTITION_SIZE := true

TARGET_PRODUCT_PROP := device/ti/am62x/product.prop
ifeq ($(TARGET_ADB_USER_ENABLE), true)
TARGET_PRODUCT_PROP += device/ti/am62x/cts.prop
endif # eq $(TARGET_ADB_USER_ENABLE), true

PRODUCT_PACKAGES += \
	android.hardware.fastboot@1.1 \
	android.hardware.fastboot@1.1-impl-mock \
	fastbootd

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

# TODO(b/218588089) remove this once cuttlefish can drop HIDL.
# This adds hwservicemanager and the allocator service to the device.
PRODUCT_PACKAGES += \
	hwservicemanager \
	android.hidl.allocator@1.0-service

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
	com.android.hardware.boot \
	android.hardware.boot-service.default_recovery

#copy xml file to tell PackageManager that the system supports Verified Boot
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.software.verified_boot.xml:system/etc/permissions/android.software.verified_boot.xml

PRODUCT_SHIPPING_API_LEVEL := 35
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false
# Enforce the Product interface
PRODUCT_PRODUCT_VNDK_VERSION := current

# Power HAL
PRODUCT_PACKAGES += com.android.hardware.power

# Health: Install default binderized implementation to vendor.
PRODUCT_PACKAGES += \
	com.google.cf.health \
	android.hardware.health-service.cuttlefish_recovery

# Health Storage
PRODUCT_PACKAGES += \
	com.google.cf.health.storage

ifneq ($(TARGET_BUILD_VARIANT), user)
PRODUCT_VENDOR_PROPERTIES += \
	persist.logd.logpersistd=logcatd
endif

# Public Libraries
PRODUCT_COPY_FILES += \
	device/ti/am62x/public.libraries.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt

# USB HAL
PRODUCT_PACKAGES += \
	com.android.hardware.usb.generic

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml


PRODUCT_PACKAGES += android.hardware.drm@latest-service.clearkey

# Thermal
PRODUCT_PACKAGES += \
	com.android.hardware.thermal.ti

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
	device/ti/am62x/android.hardware.hardware_keystore.optee-keymint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.hardware_keystore.optee-keymint.xml \
	frameworks/native/data/etc/android.software.secure_lock_screen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.secure_lock_screen.xml

PRODUCT_COPY_FILES += \
	device/ti/am62x/init.am62x.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.$(PRODUCT_PLATFORM).rc \
	device/ti/am62x/init.am62x.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.$(PRODUCT_PLATFORM).usb.rc

# RecoveryOS
PRODUCT_COPY_FILES += \
	device/ti/am62x/init.recovery.am62x.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.$(PRODUCT_PLATFORM).rc

# Memtrack
PRODUCT_PACKAGES += \
	android.hardware.memtrack-service.example

# Dumpstate
PRODUCT_PACKAGES += \
	android.hardware.dumpstate-service.example

PRODUCT_PACKAGES += \
	Launcher3QuickStep \
	ThemePicker

# Demo apps
PRODUCT_PACKAGES_DEBUG += cabin_demo

# i2c-tools for Display
PRODUCT_PACKAGES_DEBUG += i2ctransfer

# Include hardware projects (HALs)
$(call inherit-product-if-exists, hardware/ti/am62x/am62x.mk)
$(call inherit-product, hardware/ti/am62x/light/lights.mk)

# Storage: for factory reset protection feature
PRODUCT_PROPERTY_OVERRIDES += \
	ro.frp.pst=/dev/block/by-name/frp

$(call inherit-product, device/ti/am62x/shared/graphics/device_vendor.mk)
$(call inherit-product, device/ti/am62x/shared/camera/device_vendor.mk)
$(call inherit-product, device/ti/am62x/shared/audio/device_vendor.mk)
$(call inherit-product, device/ti/am62x/shared/media/device_vendor.mk)
$(call inherit-product, device/ti/am62x/shared/wifi/device_vendor.mk)
$(call inherit-product, device/ti/am62x/shared/bluetooth/device_vendor.mk)
