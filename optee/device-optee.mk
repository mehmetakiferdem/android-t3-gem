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

$(call inherit-product, device/ti/am62x/optee/kmgk.mk)

# optee
OPTEE_OS_DIR := vendor/linaro/optee-os
OPTEE_TA_TARGETS := ta_arm64
OPTEE_CFG_ARM64_CORE := y

CFG_SECSTOR_TA_MGMT_PTA := y
CFG_SECURE_DATA_PATH := y
OPTEE_CFG_CORE_HEAP_SIZE=131072

CFG_TEE_FS_PARENT_PATH := /mnt/vendor/persist/tee
CFG_TEE_CLIENT_LOAD_PATH := /vendor/lib/

BUILD_OPTEE_MK := device/ti/am62x/optee/build_optee.mk

PRODUCT_PACKAGES += \
    libteec \
    tee-supplicant

PRODUCT_COPY_FILES += \
    device/ti/am62x/optee/init.optee.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.optee.rc

# tee-supplicant test plugin
PRODUCT_PACKAGES_DEBUG += f07bfc66-958c-4a15-99c0-260e4e7375dd.plugin

# xtest
PRODUCT_PACKAGES_DEBUG += xtest

# Trusted Applications
define optee-add-ta
$(eval PRODUCT_COPY_FILES += $(1):$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/$(notdir $(1)))
endef
# xtest Trusted Applications
XTEST_TRUSTED_APPLICATIONS += 12345678-5b69-11e4-9dbb-101f74f00099.ta # sdp_basic
XTEST_TRUSTED_APPLICATIONS += 873bcd08-c2c3-11e6-a937-d0bf9c45c61c.ta # socket
XTEST_TRUSTED_APPLICATIONS += 5b9e0e40-2636-11e1-ad9e-0002a5d5c51b.ta # os_test
XTEST_TRUSTED_APPLICATIONS += ffd2bded-ab7d-4988-95ee-e4962fff7154.ta # os_test_lib
XTEST_TRUSTED_APPLICATIONS += 5ce0c432-0ab0-40e5-a056-782ca0e6aba2.ta # concurrent_large
XTEST_TRUSTED_APPLICATIONS += b689f2a7-8adf-477a-9f99-32e90c0ad0a2.ta # storage
XTEST_TRUSTED_APPLICATIONS += ee90d523-90ad-46a0-859d-8eea0b150086.ta # tpm_log_test
XTEST_TRUSTED_APPLICATIONS += c3f6e2c0-3548-11e1-b86c-0800200c9a66.ta # create_fail_test
XTEST_TRUSTED_APPLICATIONS += 731e279e-aafb-4575-a771-38caa6f0cca6.ta # storage2
XTEST_TRUSTED_APPLICATIONS += cb3e5ba0-adf1-11e0-998b-0002a5d5c51b.ta # crypt
XTEST_TRUSTED_APPLICATIONS += d17f73a0-36ef-11e1-984a-0002a5d5c51b.ta # rpc_test
XTEST_TRUSTED_APPLICATIONS += f157cda0-550c-11e5-a6fa-0002a5d5c51b.ta # storage_benchmark
XTEST_TRUSTED_APPLICATIONS += e626662e-c0e2-485c-b8c8-09fbce6edf3d.ta # aes_perf
XTEST_TRUSTED_APPLICATIONS += e13010e0-2ae1-11e5-896a-0002a5d5c51b.ta # concurrent
XTEST_TRUSTED_APPLICATIONS += b3091a65-9751-4784-abf7-0298a7cc35ba.ta # os_test_lib_dl
XTEST_TRUSTED_APPLICATIONS += a4c04d50-f180-11e8-8eb2-f2801f1b9fd1.ta # sims_keepalive
XTEST_TRUSTED_APPLICATIONS += 614789f2-39c0-4ebf-b235-92b32ac107ed.ta # sha_perf
XTEST_TRUSTED_APPLICATIONS += 528938ce-fc59-11e8-8eb2-f2801f1b9fd1.ta # miss
XTEST_TRUSTED_APPLICATIONS += e6a33ed4-562b-463a-bb7e-ff5e15a493c8.ta # sims
XTEST_TRUSTED_APPLICATIONS += 25497083-a58a-4fc5-8a72-1ad7b69b8562.ta # large
define optee-add-all-xtest-ta
$(foreach ta,$(XTEST_TRUSTED_APPLICATIONS), $(call optee-add-ta, $(1)/$(ta)))
endef

$(call optee-add-ta, vendor/ti/am62x/optee/ta/380231ac-fb99-47ad-a689-9e017eb6e78a.ta) # supp_plugin
$(call optee-add-all-xtest-ta, vendor/ti/am62x/optee/ta)

# gatekeeper
$(call optee-add-ta, vendor/ti/am62x/optee/ta/4d573443-6a56-4272-ac6f-2425af9ef9bb.ta)
# keymaster
$(call optee-add-ta, vendor/ti/am62x/optee/ta/dba51a17-0563-11e7-93b1-6fa7b0071a51.ta)
