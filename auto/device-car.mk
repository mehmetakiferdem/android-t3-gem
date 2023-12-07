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
ENABLE_EVS_SERVICE := true
ENABLE_CAREVSSERVICE_SAMPLE := true
ENABLE_SAMPLE_EVS_APP := true
ENABLE_CARTELEMETRY_SERVICE := true
ENABLE_CAMERA_SERVICE := true
ENABLE_REAR_VIEW_CAMERA_SAMPLE := true

include device/ti/am62x/auto/BoardConfig_car.mk

# Overlays
PRODUCT_PACKAGES += \
    AndroidAM62Overlay \
    SettingsProviderAM62Overlay \
    CarServiceAM62Overlay

TARGET_BOARD_INFO_FILE ?= device/google/cuttlefish/shared/auto/android-info.txt

# Bluetooth Audio
PRODUCT_PACKAGES += android.hardware.bluetooth.audio@2.1-impl 

BOARD_SEPOLICY_DIRS += device/ti/am62x/auto/sepolicy/vhal
BOARD_SEPOLICY_DIRS += device/ti/am62x/auto/sepolicy/vendor
BOARD_SEPOLICY_DIRS += device/ti/am62x/auto/sepolicy/audio
BOARD_SEPOLICY_DIRS += device/ti/am62x/auto/sepolicy/evs

# Occupant Awareness HAL
BOARD_SEPOLICY_DIRS += packages/services/Car/car_product/occupant_awareness/sepolicy

# AudioControl HAL
PRODUCT_PACKAGES += android.hardware.automotive.audiocontrol-service.example

PRODUCT_PACKAGES += android.hardware.soundtrigger@2.3-impl

PRODUCT_ENFORCE_RRO_TARGETS := framework-res

TARGET_NO_TELEPHONY := true
PRODUCT_COPY_FILES += \
    device/ti/am62x/auto/evs/evs_app_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/automotive/evs/config_override.json
#
# GPS
#
PRODUCT_PACKAGES += \
    android.hardware.gnss-service.example

### For local provisioning 
# FOR TESTING ONLY
PRODUCT_PACKAGES += FrameworksServicesTests

# CAN bus HAL
PRODUCT_PACKAGES += android.hardware.automotive.can-service
PRODUCT_PACKAGES_DEBUG += canhalctrl \
    canhaldump \
    canhalsend

# Remote access HAL
PRODUCT_PACKAGES += android.hardware.automotive.remoteaccess@V1-default-service \
	 android.hardware.automotive.ivn@V1-default-service \

DEVICE_PACKAGE_OVERLAYS := device/ti/am62x/auto/overlay
