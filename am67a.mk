#
# Copyright (C) 2025 Texas Instruments Incorporated - http://www.ti.com/
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
TARGET_KERNEL_USE ?= 6.12
TARGET_BOOTLOADER_VERSION ?= 2025.01

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, device/ti/am62x/am67a/device.mk)

PRODUCT_NAME := am67a
PRODUCT_DEVICE := am67a
PRODUCT_BRAND := TI
PRODUCT_MODEL := AOSP on AM67A EVM
PRODUCT_MANUFACTURER := TexasInstruments
PRODUCT_CHARACTERISTICS := tablet

# Boot image profiles
PRODUCT_COPY_FILES +=  device/ti/am62x/shared/boot-profiles/preloaded-classes-am62p:system/etc/preloaded-classes
PRODUCT_DEX_PREOPT_BOOT_IMAGE_PROFILE_LOCATION := device/ti/am62x/shared/boot-profiles/boot-image-profile-am62p.txt

# Set SOC information
PRODUCT_VENDOR_PROPERTIES += \
	ro.soc.manufacturer=$(PRODUCT_MANUFACTURER) \
	ro.soc.model=$(PRODUCT_DEVICE)

# clean-up all unknown PRODUCT_PACKAGES
allowed_list := product_manifest.xml
allowed_list += android.hardware.health@2.0-impl-default.recovery
allowed_list += DeviceDiagnostics
$(call enforce-product-packages-exist, $(allowed_list))

include device/ti/am62x/optee/device-optee.mk

# Include vendor binaries
$(call inherit-product-if-exists, vendor/ti/am62x/am62p.mk)

