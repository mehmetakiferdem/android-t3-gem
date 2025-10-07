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
# optee-client (libteec and tee-supplicant)
include vendor/linaro/optee_client/optee_client.device.mk
$(call soong_config_set,optee_client,cfg_tee_fs_parent_path,/mnt/vendor/persist/tee)
$(call soong_config_set,optee_client,rpmb_emu,false)

PRODUCT_PACKAGES += \
	libteec \
	tee-supplicant

PRODUCT_COPY_FILES += \
	device/ti/am62x/optee/init.optee.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.optee.rc

# tee-supplicant test plugin
PRODUCT_PACKAGES_DEBUG += f07bfc66-958c-4a15-99c0-260e4e7375dd.plugin

# xtest
PRODUCT_PACKAGES_DEBUG += xtest
# gatekeeper
PRODUCT_VENDOR_PROPERTIES += ro.hardware.gatekeeper=optee
PRODUCT_PACKAGES += \
	android.hardware.gatekeeper-service.optee

# keymaster
PRODUCT_VENDOR_PROPERTIES += ro.hardware.keystore=optee
PRODUCT_PACKAGES += android.hardware.security.keymint-service.optee

PRODUCT_COPY_FILES += \
	device/ti/am62x/android.hardware.hardware_keystore.optee-keymint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.hardware_keystore.optee-keymint.xml

