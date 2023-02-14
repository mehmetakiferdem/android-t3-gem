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

# gatekeeper
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.gatekeeper=optee
PRODUCT_PACKAGES += \
     android.hardware.gatekeeper@1.0-service.optee

# keymaster
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.keystore=optee
PRODUCT_PACKAGES += \
     android.hardware.keymaster@3.0-service.optee \
     wait_for_keymaster_optee
