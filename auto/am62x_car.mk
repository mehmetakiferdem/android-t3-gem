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
TARGET_KERNEL_USE ?= 6.1

include device/ti/am62x/optee/device-optee.mk
$(call inherit-product, device/google_car/common/pre_google_car.mk)
$(call inherit-product, device/ti/am62x/auto/device-car.mk)
$(call inherit-product, device/google_car/common/post_google_car.mk)

PRODUCT_PACKAGE_OVERLAYS := device/ti/am62x/auto/overlay
$(call inherit-product, packages/services/Car/car_product/build/car.mk)

PRODUCT_NAME := am62x_car
PRODUCT_DEVICE := am62x
PRODUCT_BRAND := TI
PRODUCT_MODEL := AOSP Car on AM62X EVM
PRODUCT_MANUFACTURER := TexasInstruments

# Set SOC information
PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=$(PRODUCT_MANUFACTURER) \
    ro.soc.model=$(PRODUCT_DEVICE)
