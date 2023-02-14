#
# Copyright 2020 BayLibre SAS
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
# optee

OPTEE_OS_DIR := vendor/linaro/optee-os
OPTEE_TA_TARGETS := ta_arm64
OPTEE_CFG_ARM64_CORE := y

CFG_SECSTOR_TA_MGMT_PTA := y
CFG_SECURE_DATA_PATH := y

CFG_TEE_FS_PARENT_PATH := /mnt/vendor/persist/tee
CFG_TEE_CLIENT_LOAD_PATH := /vendor/lib/

BUILD_OPTEE_MK := $(LOCAL_PATH)/build_optee.mk

PRODUCT_PACKAGES += \
    libteec \
    tee-supplicant

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.optee.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.optee.rc

# tee-supplicant test plugin
PRODUCT_PACKAGES_DEBUG += f07bfc66-958c-4a15-99c0-260e4e7375dd.plugin
