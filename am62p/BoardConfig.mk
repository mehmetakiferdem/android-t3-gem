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

TARGET_BOARD_PLATFORM := am62p
TARGET_BOOTLOADER_BOARD_NAME := am62p

BOARD_USERDATAIMAGE_PARTITION_SIZE := 26744696832
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

BOARD_KERNEL_CMDLINE += cma=768M

BOARD_BOOTCONFIG += androidboot.hardware=am62p

# Copy Bootloader prebuilts and prebuilts images
PRODUCT_COPY_FILES += \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62px-sk/tiboot3-hsfs.bin:$(TARGET_OUT)/tiboot3-am62px-sk-hsfs.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62px-sk/tispl.bin:$(TARGET_OUT)/tispl-am62px-sk.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62px-sk/u-boot.img:$(TARGET_OUT)/u-boot-am62px-sk.img \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62px-sk-dfu/tiboot3-hsfs.bin:$(TARGET_OUT)/tiboot3-am62px-sk-dfu-hsfs.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62px-sk-dfu/tispl.bin:$(TARGET_OUT)/tispl-am62px-sk-dfu.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62px-sk-dfu/u-boot.img:$(TARGET_OUT)/u-boot-am62px-sk-dfu.img

# Copy snagrecover config file
PRODUCT_COPY_FILES += \
	device/ti/am62x/config/dfu/am62px-sk-evm-hsfs.yaml:$(TARGET_OUT)/am62px-sk-evm-hsfs.yaml

include device/ti/am62x/BoardConfig-common.mk
