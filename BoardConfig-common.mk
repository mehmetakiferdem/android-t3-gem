#
# Copyright 2022 Texas Instruments Incorporated - http://www.ti.com/
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
ifndef TARGET_MODE_BL
ifeq ($(TARGET_BUILD_VARIANT), user)
ifeq ($(FACTORY_BUILD), true)
TARGET_MODE_BL := factory
else
TARGET_MODE_BL := release
endif
else
TARGET_MODE_BL := debug
endif
endif

-include device/ti/am62x/shared/bootloader/BoardConfig.mk
TARGET_BOOTLOADER_VERSION ?= 2025.01 
BOOTLOADERS_BINARIES := vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/

# Primary Arch
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

TARGET_IS_64_BIT := true

BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA256_RSA4096
BOARD_AVB_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem

BOARD_USES_METADATA_PARTITION := true

# Treble
PRODUCT_FULL_TREBLE := true
BOARD_VNDK_VERSION := current
TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := false

# AB support
TARGET_NO_RECOVERY := true

# Recovery
TARGET_RECOVERY_FSTAB_GENRULE := gen_fstab_am62_mmc

AB_OTA_UPDATER := true

AB_OTA_PARTITIONS := \
	boot \
	dtbo \
	system \
	vendor \
	vendor_boot \
	init_boot \
	vendor_dlkm \
	system_dlkm \
	vbmeta \
	vbmeta_vendor_dlkm \
	vbmeta_system_dlkm

# FS Configuration
BOARD_BOOTIMAGE_PARTITION_SIZE := 41943040 # 40MiB
BOARD_PREBUILT_DTBOIMAGE := device/ti/am62x-kernel/kernel/$(TARGET_KERNEL_USE)/dtbo/dtbo.img
BOARD_DTBOIMG_PARTITION_SIZE := 8388608 # 8 MiB
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE ?= ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_F2FS := true
TARGET_COPY_OUT_VENDOR := vendor

# Vendor boot partition
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 33554432

# Super partition
TARGET_USE_DYNAMIC_PARTITIONS := true
BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
BOARD_SUPER_PARTITION_GROUPS := db_dynamic_partitions
BOARD_DB_DYNAMIC_PARTITIONS_PARTITION_LIST := system vendor
BOARD_SUPER_PARTITION_SIZE := 4831838208
BOARD_DB_DYNAMIC_PARTITIONS_SIZE := 2411724800

# Vendor DLKM partition
BOARD_USES_VENDOR_DLKMIMAGE := true
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
BOARD_DB_DYNAMIC_PARTITIONS_PARTITION_LIST += vendor_dlkm

# System DLKM partition
BOARD_USES_SYSTEM_DLKMIMAGE := true
BOARD_SYSTEM_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_SYSTEM_DLKM := system_dlkm
BOARD_DB_DYNAMIC_PARTITIONS_PARTITION_LIST += system_dlkm

TARGET_SCREEN_DENSITY ?= 240

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_WIPE := device/ti/am62x/recovery.wipe

# Boot Image v4 support
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true

# GKI-related variables.
BOARD_USES_GENERIC_KERNEL_IMAGE := true

# No recovery
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE :=

BOARD_BOOT_HEADER_VERSION := 4
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_KERNEL_OFFSET      := 0x82000000
BOARD_RAMDISK_OFFSET := 0xd0000000
BOARD_RAMDISK_USE_LZ4 := true
BOARD_MKBOOTIMG_ARGS := --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --pagesize 4096

BOARD_BOOTCONFIG += androidboot.load_modules_parallel=true

#fstab
ifeq ($(TARGET_SDCARD_BOOT), true)
BOARD_BOOTCONFIG += androidboot.fstab_suffix=am62.sdcard.avb
BOARD_BOOTCONFIG += androidboot.boot_devices=bus@f0000/fa00000.mmc
else
BOARD_BOOTCONFIG += androidboot.fstab_suffix=am62.mmc.avb
BOARD_BOOTCONFIG += androidboot.boot_devices=bus@f0000/fa10000.mmc
endif

# Init Boot partition
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 0x800000
BOARD_MKBOOTIMG_INIT_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

ifneq ($(TARGET_BUILD_VARIANT), user)
BOARD_KERNEL_CMDLINE += console=ttyS2,115200
BOARD_KERNEL_CMDLINE += printk.devkmsg=on
endif
BOARD_KERNEL_CMDLINE += init=/init
BOARD_KERNEL_CMDLINE += quiet
BOARD_KERNEL_CMDLINE += firmware_class.path=/vendor/firmware
BOARD_KERNEL_CMDLINE += mem_sleep_default=deep
BOARD_KERNEL_CMDLINE += 8250.nr_uarts=10

DEVICE_MANIFEST_FILE += device/ti/am62x/manifest.xml

BOARD_SEPOLICY_DIRS += device/ti/am62x/sepolicy/common/
ifeq ($(TARGET_SDCARD_BOOT), true)
BOARD_SEPOLICY_DIRS += device/ti/am62x/sepolicy/sdcard/
else
BOARD_SEPOLICY_DIRS += device/ti/am62x/sepolicy/mmc/
endif
PRODUCT_PRIVATE_SEPOLICY_DIRS += device/ti/am62x/sepolicy-private

# Copy Bootloader prebuilts and prebuilts images
$(foreach board,$(BOARD_LIST), \
  $(eval TIBOOT3_HSFS := $(wildcard $(BOOTLOADERS_BINARIES)/$(board)/tiboot3-$(TARGET_MODE_BL)-hsfs.bin)) \
  $(eval TIBOOT3_GP := $(wildcard $(BOOTLOADERS_BINARIES)/$(board)/tiboot3-$(TARGET_MODE_BL)-gp.bin)) \
  $(call copy_bl_binaries,$(BOOTLOADERS_BINARIES),$(board),$(TIBOOT3_HSFS),$(TIBOOT3_GP)) \
)

PRODUCT_COPY_FILES += \
	vendor/ti/am62x/binaries/persist.img:$(TARGET_OUT)/persist.img \
	vendor/ti/am62x/binaries/metadata.img:$(TARGET_OUT)/metadata.img \
	device/ti/am62x-kernel/kernel/$(TARGET_KERNEL_USE)/dtbo/dtbo.img:$(TARGET_OUT)/dtbo-unsigned.img

# Copy Android Flashing Script
PRODUCT_COPY_FILES += \
	device/ti/am62x/flashall.sh:$(TARGET_OUT)/flashall.sh

# USB Hal
BOARD_SEPOLICY_DIRS += \
	hardware/ti/am62x/usb/aidl/sepolicy

# Enable chained vbmeta for boot images
BOARD_AVB_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_BOOT_ALGORITHM := SHA256_RSA4096
BOARD_AVB_BOOT_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 2

# Enable chained vbmeta for init_boot images
BOARD_AVB_INIT_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_INIT_BOOT_ALGORITHM := SHA256_RSA4096
BOARD_AVB_INIT_BOOT_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_INIT_BOOT_ROLLBACK_INDEX_LOCATION := 3

# Enabled chained vbmeta for vendor_dlkm
BOARD_AVB_VBMETA_CUSTOM_PARTITIONS := vendor_dlkm system_dlkm
BOARD_AVB_VBMETA_VENDOR_DLKM := vendor_dlkm
BOARD_AVB_VBMETA_VENDOR_DLKM_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_VBMETA_VENDOR_DLKM_ALGORITHM := SHA256_RSA4096
BOARD_AVB_VBMETA_VENDOR_DLKM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_VENDOR_DLKM_ROLLBACK_INDEX_LOCATION := 4

# Enabled chained vbmeta for system_dlkm
BOARD_AVB_VBMETA_SYSTEM_DLKM := system_dlkm
BOARD_AVB_VBMETA_SYSTEM_DLKM_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_VBMETA_SYSTEM_DLKM_ALGORITHM := SHA256_RSA4096
BOARD_AVB_VBMETA_SYSTEM_DLKM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_DLKM_ROLLBACK_INDEX_LOCATION := 5

BOARD_AVB_SYSTEM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_VENDOR_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_VENDOR_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_SYSTEM_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256

# Dynamically generate BOARD_VENDOR_RAMDISK_KERNEL_MODULES from ramdisk directory
# Exclude pvrsrvkm modules as they will be added conditionally based on platform
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(shell find device/ti/am62x-kernel/kernel/$(TARGET_KERNEL_USE)/ramdisk -name '*.ko' ! -name 'pvrsrvkm*.ko' 2>/dev/null | sort)

# Add platform-specific PowerVR kernel modules
RAMDISK_MODULE_PATH := device/ti/am62x-kernel/kernel/$(TARGET_KERNEL_USE)/ramdisk

ifeq ($(PRODUCT_PLATFORM),am62x)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += $(RAMDISK_MODULE_PATH)/pvrsrvkm.ko
else ifneq ($(filter am62p am67a,$(PRODUCT_PLATFORM)),)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += $(RAMDISK_MODULE_PATH)/pvrsrvkm_am62p.ko
endif

BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD +=  $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES)

# =============================================================================
# DLKM module configuration using organized directory structure
# =============================================================================

# Path to the organized modules directories
VENDOR_DLKM_MODULES_DIR := device/ti/am62x-kernel/kernel/$(TARGET_KERNEL_USE)/vendor_dlkm
SYSTEM_DLKM_MODULES_DIR := device/ti/am62x-kernel/kernel/$(TARGET_KERNEL_USE)/system_dlkm

# Generate the module lists from organized directories
BOARD_VENDOR_DLKM_MODULES := $(shell find $(VENDOR_DLKM_MODULES_DIR) -name '*.ko' 2>/dev/null | sort)
BOARD_SYSTEM_DLKM_MODULES := $(shell find $(SYSTEM_DLKM_MODULES_DIR) -name '*.ko' 2>/dev/null | sort)

# Copy vendor_dlkm modules to /vendor/lib/modules
BOARD_VENDOR_KERNEL_MODULES += $(BOARD_VENDOR_DLKM_MODULES)

# Copy system_dlkm modules to /system_dlkm/lib/modules
BOARD_SYSTEM_KERNEL_MODULES += $(BOARD_SYSTEM_DLKM_MODULES)
BOARD_SYSTEM_KERNEL_MODULES_LOAD += $(BOARD_SYSTEM_KERNEL_MODULES)

-include device/ti/am62x/optee/BoardConfig.mk
-include device/ti/am62x/shared/graphics/BoardConfig.mk
-include device/ti/am62x/shared/camera/BoardConfig.mk
-include device/ti/am62x/shared/audio/BoardConfig.mk
-include device/ti/am62x/shared/media/BoardConfig.mk
-include device/ti/am62x/shared/wifi/BoardConfig.mk
-include device/ti/am62x/shared/bluetooth/BoardConfig.mk
