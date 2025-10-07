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

BOARD_USERDATAIMAGE_PARTITION_SIZE := 10662837248

BOARD_KERNEL_CMDLINE += cma=512M

BOARD_BOOTCONFIG += androidboot.hardware=am62x

# Copy Bootloader prebuilts and prebuilts images
PRODUCT_COPY_FILES += \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62x-lp-sk/tiboot3.bin:$(TARGET_OUT)/tiboot3-am62x-lp-sk.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62x-lp-sk/tiboot3-hsfs.bin:$(TARGET_OUT)/tiboot3-am62x-lp-sk-hsfs.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62x-lp-sk/tispl.bin:$(TARGET_OUT)/tispl-am62x-lp-sk.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62x-lp-sk/u-boot.img:$(TARGET_OUT)/u-boot-am62x-lp-sk.img \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62x-sk/tiboot3.bin:$(TARGET_OUT)/tiboot3-am62x-sk.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62x-sk/tiboot3-hsfs.bin:$(TARGET_OUT)/tiboot3-am62x-sk-hsfs.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62x-sk/tispl.bin:$(TARGET_OUT)/tispl-am62x-sk.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62x-sk/u-boot.img:$(TARGET_OUT)/u-boot-am62x-sk.img \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62x-lp-sk-dfu/tiboot3.bin:$(TARGET_OUT)/tiboot3-am62x-lp-sk-dfu.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62x-lp-sk-dfu/tiboot3-hsfs.bin:$(TARGET_OUT)/tiboot3-am62x-lp-sk-dfu-hsfs.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62x-lp-sk-dfu/tispl.bin:$(TARGET_OUT)/tispl-am62x-lp-sk-dfu.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62x-lp-sk-dfu/u-boot.img:$(TARGET_OUT)/u-boot-am62x-lp-sk-dfu.img \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62x-sk-dfu/tiboot3.bin:$(TARGET_OUT)/tiboot3-am62x-sk-dfu.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62x-sk-dfu/tiboot3-hsfs.bin:$(TARGET_OUT)/tiboot3-am62x-sk-dfu-hsfs.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62x-sk-dfu/tispl.bin:$(TARGET_OUT)/tispl-am62x-sk-dfu.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am62x-sk-dfu/u-boot.img:$(TARGET_OUT)/u-boot-am62x-sk-dfu.img \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am625-beagleplay/tiboot3.bin:$(TARGET_OUT)/tiboot3-am625-beagleplay.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am625-beagleplay/tispl.bin:$(TARGET_OUT)/tispl-am625-beagleplay.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am625-beagleplay/u-boot.img:$(TARGET_OUT)/u-boot-am625-beagleplay.img \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am625-beagleplay-dfu/tiboot3.bin:$(TARGET_OUT)/tiboot3-am625-beagleplay-dfu.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am625-beagleplay-dfu/tispl.bin:$(TARGET_OUT)/tispl-am625-beagleplay-dfu.bin \
	vendor/ti/am62x/bootloader/$(TARGET_BOOTLOADER_VERSION)/am625-beagleplay-dfu/u-boot.img:$(TARGET_OUT)/u-boot-am625-beagleplay-dfu.img

# Copy snagrecover config file
PRODUCT_COPY_FILES += \
	device/ti/am62x/config/dfu/am62x-sk-evm.yaml:$(TARGET_OUT)/am62x-sk-evm.yaml \
	device/ti/am62x/config/dfu/am62x-sk-evm-hsfs.yaml:$(TARGET_OUT)/am62x-sk-evm-hsfs.yaml \
	device/ti/am62x/config/dfu/am62x-lp-sk-evm.yaml:$(TARGET_OUT)/am62x-lp-sk-evm.yaml \
	device/ti/am62x/config/dfu/am62x-lp-sk-evm-hsfs.yaml:$(TARGET_OUT)/am62x-lp-sk-evm-hsfs.yaml \
	device/ti/am62x/config/dfu/am625-beagleplay.yaml:$(TARGET_OUT)/am625-beagleplay.yaml \

include device/ti/am62x/BoardConfig-common.mk
