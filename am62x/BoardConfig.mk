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

# Define supported board list
BOARD_LIST := am62x-sk am62x-sk-dfu am62x-lp-sk am62x-lp-sk-dfu am625-beagleplay am625-beagleplay-dfu

# Copy snagrecover config file
PRODUCT_COPY_FILES += \
	device/ti/am62x/config/dfu/am62x-sk-evm.yaml:$(TARGET_OUT)/am62x-sk-evm.yaml \
	device/ti/am62x/config/dfu/am62x-sk-evm-hsfs.yaml:$(TARGET_OUT)/am62x-sk-evm-hsfs.yaml \
	device/ti/am62x/config/dfu/am62x-lp-sk-evm.yaml:$(TARGET_OUT)/am62x-lp-sk-evm.yaml \
	device/ti/am62x/config/dfu/am62x-lp-sk-evm-hsfs.yaml:$(TARGET_OUT)/am62x-lp-sk-evm-hsfs.yaml \
	device/ti/am62x/config/dfu/am625-beagleplay.yaml:$(TARGET_OUT)/am625-beagleplay.yaml \

include device/ti/am62x/BoardConfig-common.mk
