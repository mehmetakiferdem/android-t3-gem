TARGET_SDCARD_BOOT := true

TARGET_KERNEL_USE ?= 6.12
TARGET_BOOTLOADER_VERSION ?= 2025.01

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, device/ti/am62x/am67a/device.mk)

PRODUCT_NAME := am67a-t3-gem-o1
PRODUCT_DEVICE := am67a
PRODUCT_BRAND := T3Gemstone
PRODUCT_MODEL := T3 Gemstone O1
PRODUCT_MANUFACTURER := T3Gemstone
PRODUCT_CHARACTERISTICS := tablet

PRODUCT_COPY_FILES += \
    device/ti/am62x/shared/boot-profiles/preloaded-classes-am67a:system/etc/preloaded-classes
PRODUCT_DEX_PREOPT_BOOT_IMAGE_PROFILE_LOCATION := \
    device/ti/am62x/shared/boot-profiles/boot-image-profile-am67a.txt

PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=TexasInstruments \
    ro.soc.model=AM67A

$(call inherit-product-if-exists, vendor/ti/am62x/am62p.mk)
