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

# Define supported board list
BOARD_LIST := am67a-evm am67a-evm-dfu am67a-beagley-ai

# Copy snagrecover config file
PRODUCT_COPY_FILES += \
	device/ti/am62x/config/dfu/am67a-evm-hsfs.yaml:$(TARGET_OUT)/am67a-evm-hsfs.yaml

include device/ti/am62x/BoardConfig-common.mk
