#
# Copyright (C) 2022 Texas Instruments Incorporated - http://www.ti.com/
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
$(call inherit-product, device/ti/am62x/am62x/device.mk)

PRODUCT_NAME := am62x
PRODUCT_DEVICE := am62x
PRODUCT_BRAND := TI
PRODUCT_MODEL := AOSP on AM62X EVM
PRODUCT_MANUFACTURER := TexasInstruments
PRODUCT_CHARACTERISTICS := tablet

# Boot image profiles
PRODUCT_COPY_FILES +=  device/ti/am62x/shared/boot-profiles/preloaded-classes-am62x:system/etc/preloaded-classes
PRODUCT_DEX_PREOPT_BOOT_IMAGE_PROFILE_LOCATION := device/ti/am62x/shared/boot-profiles/boot-image-profile-am62x.txt

# Set lowram options
PRODUCT_VENDOR_PROPERTIES += \
	dalvik.vm.heapstartsize=1m \
	dalvik.vm.heapgrowthlimit=192m \
	dalvik.vm.heapsize=384m \
	dalvik.vm.heaptargetutilization=0.90 \
	dalvik.vm.heapminfree=512k \
	dalvik.vm.heapmaxfree=2m \
	dalvik.vm.usejit=true \
	ro.lmk.medium=700 \
	ro.lmk.critical_upgrade=true \
	ro.lmk.upgrade_pressure=40 \
	ro.lmk.downgrade_pressure=60 \
	ro.lmk.kill_heaviest_task=false \
	pm.dexopt.downgrade_after_inactive_days=10 \
	pm.dexopt.shared=quicken

PRODUCT_VENDOR_PROPERTIES += \
	ro.config.low_ram=true

# WORKAROUND for OTA:
#
# With limited memory, OTA is broken when we apply it via update_engine.
# Indeed when we switch to the new slot, snapuserd_proxy fails and the device reboot.
#
# When ro.config.low_ram=true and ro.config.per_app_memcg property is not set,
# UsePerAppMemcg will return true and so snapuserd_proxy will try to access to:
# /dev/memcg/apps*
#
# However these required directories are not yet present.
#
# A patch has been made to fix this issue:
# https://android-review.googlesource.com/c/platform/system/core/+/2820943
#
# This fix is not yet present in our AOSP.
# As workaround we manually set: ro.config.per_app_memcg=false
# Thus UsePerAppMemcg will return false and snapuserd_proxy won't try to access
# to /dev/memcg/apps*.
PRODUCT_VENDOR_PROPERTIES += \
	ro.config.per_app_memcg=false

# Speed profile services and wifi-service to reduce RAM and storage.
PRODUCT_SYSTEM_SERVER_COMPILER_FILTER := speed-profile

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
$(call inherit-product-if-exists, vendor/ti/am62x/am62x.mk)
