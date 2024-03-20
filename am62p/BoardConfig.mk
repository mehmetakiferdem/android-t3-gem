#
# Copyright 2023 Texas Instruments Incorporated - http://www.ti.com/
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

# Primary Arch
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

TARGET_IS_64_BIT := true
TARGET_USES_64_BIT_BINDER := true

TARGET_BOARD_PLATFORM := am62p
TARGET_BOOTLOADER_BOARD_NAME := am62p

BOARD_USERDATAIMAGE_PARTITION_SIZE := 26744827904
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

ifneq ($(TARGET_BUILD_VARIANT), user)
BOARD_KERNEL_CMDLINE += console=ttyS2,115200
endif
ifeq ($(TARGET_SDCARD_BOOT), true)
BOARD_BOOTCONFIG += androidboot.boot_devices=bus@f0000/fa00000.mmc
else
BOARD_BOOTCONFIG += androidboot.boot_devices=bus@f0000/fa10000.mmc
endif
BOARD_KERNEL_CMDLINE += cma=768M
BOARD_KERNEL_CMDLINE += 8250.nr_uarts=10

BOARD_BOOTCONFIG += androidboot.hardware=am62p 

# Copy Bootloader prebuilts and prebuilts images
PRODUCT_COPY_FILES += \
        vendor/ti/am62x/bootloader/am62px-sk/tiboot3-hsfs.bin:$(TARGET_OUT)/tiboot3-am62px-sk-hsfs.bin \
        vendor/ti/am62x/bootloader/am62px-sk/tispl.bin:$(TARGET_OUT)/tispl-am62px-sk.bin \
        vendor/ti/am62x/bootloader/am62px-sk/u-boot.img:$(TARGET_OUT)/u-boot-am62px-sk.img \
        vendor/ti/am62x/bootloader/am62px-sk-dfu/tiboot3-hsfs.bin:$(TARGET_OUT)/tiboot3-am62px-sk-dfu-hsfs.bin \
        vendor/ti/am62x/bootloader/am62px-sk-dfu/tispl.bin:$(TARGET_OUT)/tispl-am62px-sk-dfu.bin \
        vendor/ti/am62x/bootloader/am62px-sk-dfu/u-boot.img:$(TARGET_OUT)/u-boot-am62px-sk-dfu.img

# Copy snagrecover config file
PRODUCT_COPY_FILES += \
        device/ti/am62x/config/dfu/am62px-sk-evm-hsfs.yaml:$(TARGET_OUT)/am62px-sk-evm-hsfs.yaml

include device/ti/am62x/BoardConfig-common.mk
