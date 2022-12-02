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

TARGET_BOARD_PLATFORM := am62x
TARGET_BOOTLOADER_BOARD_NAME := am62x

# AVB
ifeq ($(TARGET_BUILD_VARIANT), user)
TARGET_AVB_ENABLE := true
endif

ifeq ($(TARGET_AVB_ENABLE), true)
BOARD_AVB_ENABLE := true
else
BOARD_AVB_ENABLE := false
endif

# Primary Arch
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

# Secondary Arch
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

TARGET_IS_64_BIT := true
TARGET_USES_64_BIT_BINDER := true

BOARD_USES_METADATA_PARTITION := true

# Treble
PRODUCT_FULL_TREBLE := true
BOARD_VNDK_VERSION := current
TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := false

# AB support
BOARD_USES_RECOVERY_AS_BOOT := true
TARGET_NO_RECOVERY := true

AB_OTA_UPDATER := true

AB_OTA_PARTITIONS := \
    boot \
    dtbo \
    system \
    vendor

ifeq ($(TARGET_AVB_ENABLE), true)
AB_OTA_PARTITIONS += vbmeta
endif

# FS Configuration
BOARD_BOOTIMAGE_PARTITION_SIZE := 41943040 # 40MiB
BOARD_PREBUILT_DTBOIMAGE := device/ti/am62x-kernel/kernel/5.10/dtbo.img
BOARD_DTBOIMG_PARTITION_SIZE := 8388608 # 8 MiB
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE ?= ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_PARTITION_SIZE := 10696523776
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_F2FS := true
TARGET_COPY_OUT_VENDOR := vendor

# Super partition
TARGET_USE_DYNAMIC_PARTITIONS := true
BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
BOARD_SUPER_PARTITION_GROUPS := db_dynamic_partitions
BOARD_DB_DYNAMIC_PARTITIONS_PARTITION_LIST := system vendor
BOARD_SUPER_PARTITION_SIZE := 4831838208
BOARD_DB_DYNAMIC_PARTITIONS_SIZE := 2411724800
BOARD_SUPER_PARTITION_METADATA_DEVICE := super

TARGET_SCREEN_DENSITY ?= 240

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_FSTAB := device/ti/am62x/fstab.am62x
TARGET_RECOVERY_WIPE := device/ti/am62x/recovery.wipe


BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_KERNEL_OFFSET      := 0x82000000
BOARD_RAMDISK_OFFSET := 0xd0000000
BOARD_MKBOOTIMG_ARGS := --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version 2
BOARD_KERNEL_CMDLINE += no_console_suspend console=ttyS2,115200 
BOARD_KERNEL_CMDLINE += printk.devkmsg=on androidboot.selinux=permissive
BOARD_KERNEL_CMDLINE += androidboot.boot_devices=bus@f0000/fa10000.mmc
BOARD_KERNEL_CMDLINE += init=/init
BOARD_KERNEL_CMDLINE += cma=512M
BOARD_KERNEL_CMDLINE += firmware_class.path=/vendor/firmware
BOARD_KERNEL_CMDLINE += androidboot.hardware=am62x
BOARD_KERNEL_CMDLINE += fw_devlink=permissive

DEVICE_MANIFEST_FILE := device/ti/am62x/manifest.xml

BOARD_SEPOLICY_DIRS += device/ti/am62x/sepolicy
PRODUCT_PRIVATE_SEPOLICY_DIRS += device/ti/am62x/sepolicy-private

BUILD_BROKEN_VENDOR_PROPERTY_NAMESPACE := true

# Copy Bootloader prebuilts and prebuilts images
PRODUCT_COPY_FILES += \
        vendor/ti/am62x/bootloader/tiboot3.bin:$(TARGET_OUT)/tiboot3.bin \
        vendor/ti/am62x/bootloader/tispl.bin:$(TARGET_OUT)/tispl.bin \
        vendor/ti/am62x/bootloader/u-boot.img:$(TARGET_OUT)/u-boot.img \
        vendor/ti/am62x/binaries/persist.img:$(TARGET_OUT)/persist.img \
        device/ti/am62x-kernel/kernel/5.10/dtbo.img:$(TARGET_OUT)/dtbo-unsigned.img

# Copy Android Flashing Script
PRODUCT_COPY_FILES += \
        device/ti/am62x/flashall.sh:$(TARGET_OUT)/flashall.sh \

# Copy kernel modules into /vendor/lib/modules
BOARD_ALL_MODULES := $(shell find device/ti/am62x-kernel/kernel/5.10 -type f -iname '*.ko')
BOARD_VENDOR_KERNEL_MODULES += $(BOARD_ALL_MODULES)

BOARD_RECOVERY_KERNEL_MODULES := \
        device/ti/am62x-kernel/kernel/5.10/dwc3.ko \
        device/ti/am62x-kernel/kernel/5.10/dwc3-am62.ko \
        device/ti/am62x-kernel/kernel/5.10/typec.ko \
        device/ti/am62x-kernel/kernel/5.10/roles.ko \
        device/ti/am62x-kernel/kernel/5.10/tps6598x.ko \
        device/ti/am62x-kernel/kernel/5.10/xhci-plat-hcd.ko \
        device/ti/am62x-kernel/kernel/5.10/sa2ul.ko \
        device/ti/am62x-kernel/kernel/5.10/crct10dif-ce.ko \
        device/ti/am62x-kernel/kernel/5.10/cdns-dphy.ko \
        device/ti/am62x-kernel/kernel/5.10/rng-core.ko \
        device/ti/am62x-kernel/kernel/5.10/omap-rng.ko

# USB Hal
BOARD_SEPOLICY_DIRS += \
        hardware/ti/am62x/usb/1.2/sepolicy

ifeq ($(TARGET_AVB_ENABLE), true)
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA2048
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 2
endif

# Audio HAL
BOARD_USES_TINYHAL_AUDIO := true
TINYALSA_NO_ADD_NEW_CTRLS := true
TINYALSA_NO_CTL_GET_ID := true
TINYCOMPRESS_TSTAMP_IS_LONG := true

# generic wifi
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_ti
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_ti
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_HOSTAPD_DRIVER := NL80211
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
