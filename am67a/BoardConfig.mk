#
# Copyright 2025 Texas Instruments Incorporated - http://www.ti.com/
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

TARGET_BOARD_PLATFORM := am67a
TARGET_BOOTLOADER_BOARD_NAME := am67a

BOARD_USERDATAIMAGE_PARTITION_SIZE := 26744696832

BOARD_KERNEL_CMDLINE += cma=768M

BOARD_BOOTCONFIG += androidboot.hardware=am67a

# Copy Bootloader prebuilts and prebuilts images
PRODUCT_COPY_FILES += \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am67a-evm/tiboot3-hsfs.bin:$(TARGET_OUT)/tiboot3-am67a-evm-hsfs.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am67a-evm/tispl.bin:$(TARGET_OUT)/tispl-am67a-evm.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am67a-evm/u-boot.img:$(TARGET_OUT)/u-boot-am67a-evm.img \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am67a-evm-dfu/tiboot3-hsfs.bin:$(TARGET_OUT)/tiboot3-am67a-evm-dfu-hsfs.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am67a-evm-dfu/tispl.bin:$(TARGET_OUT)/tispl-am67a-evm-dfu.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am67a-evm-dfu/u-boot.img:$(TARGET_OUT)/u-boot-am67a-evm-dfu.img \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am67a-beagley-ai/tiboot3-hsfs.bin:$(TARGET_OUT)/tiboot3-am67a-beagley-ai-hsfs.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am67a-beagley-ai/tispl.bin:$(TARGET_OUT)/tispl-am67a-beagley-ai.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am67a-beagley-ai/u-boot.img:$(TARGET_OUT)/u-boot-am67a-beagley-ai.img

# Copy snagrecover config file
PRODUCT_COPY_FILES += \
	device/ti/am62x/config/dfu/am67a-evm-hsfs.yaml:$(TARGET_OUT)/am67a-evm-hsfs.yaml

include device/ti/am62x/BoardConfig-common.mk
