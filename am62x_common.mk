
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=1m \
    dalvik.vm.heapgrowthlimit=64m \
    dalvik.vm.heapsize=256m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=512k \
    dalvik.vm.heapmaxfree=2m \
    dalvik.vm.usejit=false

# Set SOC information
PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=$(PRODUCT_MANUFACTURER) \
    ro.soc.model=$(PRODUCT_DEVICE)

# clean-up all unknown PRODUCT_PACKAGES
allowed_list := product_manifest.xml
$(call enforce-product-packages-exist, $(allowed_list))