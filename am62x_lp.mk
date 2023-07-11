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
TARGET_WIFI_SUPPORT := false
TARGET_BL_NAME := am62x-lp-sk

TARGET_KERNEL_USE ?= 5.10

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, device/ti/am62x/device.mk)

PRODUCT_NAME := am62x_lp
PRODUCT_DEVICE := am62x
PRODUCT_BRAND := TI
PRODUCT_MODEL := AOSP on AM62X-LP EVM
PRODUCT_MANUFACTURER := TexasInstruments
PRODUCT_CHARACTERISTICS := tablet

include device/ti/am62x/am62x_common.mk
