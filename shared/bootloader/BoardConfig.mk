define copy_bl_binaries
$(eval PRODUCT_COPY_FILES += \
  $(1)/$(2)/tispl-$(TARGET_MODE_BL).bin:$(TARGET_OUT)/tispl-$(2).bin \
  $(1)/$(2)/u-boot-$(TARGET_MODE_BL).img:$(TARGET_OUT)/u-boot-$(2).img)

$(if $(3), \
  $(eval PRODUCT_COPY_FILES += $(3):$(TARGET_OUT)/tiboot3-$(2)-hsfs.bin))
$(if $(4), \
  $(eval PRODUCT_COPY_FILES += $(4):$(TARGET_OUT)/tiboot3-$(2).bin))
endef
