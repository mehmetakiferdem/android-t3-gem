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
# Primary Arch
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a53

TARGET_IS_64_BIT := false
TARGET_USES_64_BIT_BINDER := true
# Disable 64 bit mediadrmserver
TARGET_ENABLE_MEDIADRM_64 :=

TARGET_BOARD_PLATFORM := am62x
TARGET_BOOTLOADER_BOARD_NAME := am62x

BOARD_USERDATAIMAGE_PARTITION_SIZE := 10662838272
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

ifneq ($(TARGET_BUILD_VARIANT), user)
BOARD_KERNEL_CMDLINE += console=ttyS2,115200
endif
ifeq ($(TARGET_SDCARD_BOOT), true)
BOARD_BOOTCONFIG += androidboot.boot_devices=bus@f0000/fa00000.mmc
else
BOARD_BOOTCONFIG += androidboot.boot_devices=bus@f0000/fa10000.mmc
endif
BOARD_KERNEL_CMDLINE += cma=512M
BOARD_KERNEL_CMDLINE += 8250.nr_uarts=10

BOARD_BOOTCONFIG += androidboot.hardware=am62x

# Copy Bootloader prebuilts and prebuilts images
PRODUCT_COPY_FILES += \
        vendor/ti/am62x/bootloader/am62x-lp-sk/tiboot3.bin:$(TARGET_OUT)/tiboot3-am62x-lp-sk.bin \
        vendor/ti/am62x/bootloader/am62x-lp-sk/tiboot3-hsfs.bin:$(TARGET_OUT)/tiboot3-am62x-lp-sk-hsfs.bin \
        vendor/ti/am62x/bootloader/am62x-lp-sk/tispl.bin:$(TARGET_OUT)/tispl-am62x-lp-sk.bin \
        vendor/ti/am62x/bootloader/am62x-lp-sk/u-boot.img:$(TARGET_OUT)/u-boot-am62x-lp-sk.img \
        vendor/ti/am62x/bootloader/am62x-sk/tiboot3.bin:$(TARGET_OUT)/tiboot3-am62x-sk.bin \
        vendor/ti/am62x/bootloader/am62x-sk/tiboot3-hsfs.bin:$(TARGET_OUT)/tiboot3-am62x-sk-hsfs.bin \
        vendor/ti/am62x/bootloader/am62x-sk/tispl.bin:$(TARGET_OUT)/tispl-am62x-sk.bin \
        vendor/ti/am62x/bootloader/am62x-sk/u-boot.img:$(TARGET_OUT)/u-boot-am62x-sk.img \
        vendor/ti/am62x/bootloader/am62x-lp-sk-dfu/tiboot3.bin:$(TARGET_OUT)/tiboot3-am62x-lp-sk-dfu.bin \
        vendor/ti/am62x/bootloader/am62x-lp-sk-dfu/tiboot3-hsfs.bin:$(TARGET_OUT)/tiboot3-am62x-lp-sk-dfu-hsfs.bin \
        vendor/ti/am62x/bootloader/am62x-lp-sk-dfu/tispl.bin:$(TARGET_OUT)/tispl-am62x-lp-sk-dfu.bin \
        vendor/ti/am62x/bootloader/am62x-lp-sk-dfu/u-boot.img:$(TARGET_OUT)/u-boot-am62x-lp-sk-dfu.img \
        vendor/ti/am62x/bootloader/am62x-sk-dfu/tiboot3.bin:$(TARGET_OUT)/tiboot3-am62x-sk-dfu.bin \
        vendor/ti/am62x/bootloader/am62x-sk-dfu/tiboot3-hsfs.bin:$(TARGET_OUT)/tiboot3-am62x-sk-dfu-hsfs.bin \
        vendor/ti/am62x/bootloader/am62x-sk-dfu/tispl.bin:$(TARGET_OUT)/tispl-am62x-sk-dfu.bin \
        vendor/ti/am62x/bootloader/am62x-sk-dfu/u-boot.img:$(TARGET_OUT)/u-boot-am62x-sk-dfu.img \
        vendor/ti/am62x/bootloader/am625-beagleplay/tiboot3.bin:$(TARGET_OUT)/tiboot3-am625-beagleplay.bin \
        vendor/ti/am62x/bootloader/am625-beagleplay/tispl.bin:$(TARGET_OUT)/tispl-am625-beagleplay.bin \
        vendor/ti/am62x/bootloader/am625-beagleplay/u-boot.img:$(TARGET_OUT)/u-boot-am625-beagleplay.img \
        vendor/ti/am62x/bootloader/am625-beagleplay-dfu/tiboot3.bin:$(TARGET_OUT)/tiboot3-am625-beagleplay-dfu.bin \
        vendor/ti/am62x/bootloader/am625-beagleplay-dfu/tispl.bin:$(TARGET_OUT)/tispl-am625-beagleplay-dfu.bin \
        vendor/ti/am62x/bootloader/am625-beagleplay-dfu/u-boot.img:$(TARGET_OUT)/u-boot-am625-beagleplay-dfu.img

# Copy snagrecover config file
PRODUCT_COPY_FILES += \
        device/ti/am62x/config/dfu/am62x-sk-evm.yaml:$(TARGET_OUT)/am62x-sk-evm.yaml \
        device/ti/am62x/config/dfu/am62x-sk-evm-hsfs.yaml:$(TARGET_OUT)/am62x-sk-evm-hsfs.yaml \
        device/ti/am62x/config/dfu/am62x-lp-sk-evm.yaml:$(TARGET_OUT)/am62x-lp-sk-evm.yaml \
        device/ti/am62x/config/dfu/am62x-lp-sk-evm-hsfs.yaml:$(TARGET_OUT)/am62x-lp-sk-evm-hsfs.yaml \
        device/ti/am62x/config/dfu/am625-beagleplay.yaml:$(TARGET_OUT)/am625-beagleplay.yaml \

include device/ti/am62x/BoardConfig-common.mk
