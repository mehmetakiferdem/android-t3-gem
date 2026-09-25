#
# Copyright 2025 Texas Instruments Incorporated - http://www.ti.com/
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

PRODUCT_PLATFORM := am67a

$(call inherit-product, device/ti/am62x/am62p/device.mk)


# RTL8822CS WiFi firmware (T3 Gem O1)
PRODUCT_PACKAGES += linux_firmware_rtw88-rtw8822c

# RTL8822CS BT firmware (T3 Gem O1) - no Soong module exists for rtl8822cs BT
PRODUCT_COPY_FILES += \
    device/ti/am62x/firmware/rtl_bt/rtl8822cs_fw.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/rtl_bt/rtl8822cs_fw.bin \
    device/ti/am62x/firmware/rtl_bt/rtl8822cs_config.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/rtl_bt/rtl8822cs_config.bin

# Both am67a products inherit this file, and both were shipping the same two
# rough edges. full_base.mk pins PRODUCT_LOCALES to en_US, so the Turkish
# layout and dictionary LatinIME already carries were never built in and the
# language could not be selected at all. And the browser that comes down from
# handheld_product.mk is Browser2, the WebView test shell: developer chrome, a
# placeholder icon, and a package name that gives it away
# (org.chromium.webview_shell). Jelly declares overrides: ["Browser2"], so
# pulling it in replaces the shell rather than leaving two browsers installed.
PRODUCT_LOCALES := en_US tr_TR

PRODUCT_PACKAGES += \
    Jelly
