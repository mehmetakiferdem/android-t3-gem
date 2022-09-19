#
# Copyright 2022 The Android Open Source Project
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
BOARD_IS_AUTOMOTIVE := true
PRODUCT_IS_AUTO := true

include device/ti/am62x/auto/BoardConfig_car.mk

$(call inherit-product, device/ti/am62x/device.mk)

TARGET_BOARD_INFO_FILE ?= device/google/cuttlefish/shared/auto/android-info.txt

# Broadcast Radio
PRODUCT_PACKAGES += android.hardware.broadcastradio@2.0-service \
    android.hardware.automotive.vehicle@2.0-manager-lib \
    android.hardware.bluetooth.audio@2.1-impl

# vehicle HAL
PRODUCT_PACKAGES += android.hardware.automotive.vehicle@2.0-service
BOARD_SEPOLICY_DIRS += device/google/cuttlefish/shared/auto/sepolicy/vhal
BOARD_SEPOLICY_DIRS += device/google/cuttlefish/shared/auto/sepolicy/vendor

# AudioControl HAL
PRODUCT_PACKAGES += android.hardware.automotive.audiocontrol-service.example
    
# CAN bus HAL
PRODUCT_PACKAGES += android.hardware.automotive.can@1.0-service
PRODUCT_PACKAGES_DEBUG += canhalctrl \
    canhaldump \
    canhalsend

PRODUCT_PACKAGES += android.hardware.soundtrigger@2.3-impl

PRODUCT_ENFORCE_RRO_TARGETS := framework-res

TARGET_NO_TELEPHONY := true

DEVICE_MANIFEST_FILE += device/ti/am62x/auto/manifest_car.xml

PRODUCT_PROPERTY_OVERRIDES += \
	android.car.drawer.unlimited=true \
	android.car.hvac.demo=true \
	com.android.car.radio.demo=true \
	com.android.car.radio.demo.dual=true

#
# GPS
#
PRODUCT_PACKAGES += \
    android.hardware.gnss-service.example

### For local provisioning 
# FOR TESTING ONLY
PRODUCT_PACKAGES += FrameworksServicesTests
