# NOTE: each product should also add audio.primary.$(TARGET_DEVICE) to its PRODUCT_PACKAGES
PRODUCT_PACKAGES += \
	audio.r_submix.default \
	android.hardware.audio.service \
	android.hardware.audio@6.0-impl \
	android.hardware.audio.effect@6.0-impl

# Audio USB HAL
PRODUCT_PACKAGES += \
	audio.usb.default

PRODUCT_PACKAGES += audio.primary.$(PRODUCT_PLATFORM)

# Audio HAL
PRODUCT_COPY_FILES += \
	device/ti/am62x/shared/audio/config/audio_hal_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.$(PRODUCT_PLATFORM).xml

# audio policy configuration
USE_XML_AUDIO_POLICY_CONF := 1
PRODUCT_COPY_FILES += \
	device/ti/am62x/shared/audio/config/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
	frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
	frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
	frameworks/av/media/libeffects/data/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml


# Low level audio tools for debugging
PRODUCT_PACKAGES_DEBUG += \
	tinyplay \
	tinycap \
	tinymix \
	tinypcminfo \
	cplay
