
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=1m \
    dalvik.vm.heapgrowthlimit=128m \
    dalvik.vm.heapsize=256m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=512k \
    dalvik.vm.heapmaxfree=2m \
    dalvik.vm.usejit=true

# Set SOC information
PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=$(PRODUCT_MANUFACTURER) \
    ro.soc.model=$(PRODUCT_DEVICE)

# clean-up all unknown PRODUCT_PACKAGES
allowed_list := product_manifest.xml
$(call enforce-product-packages-exist, $(allowed_list))

include device/ti/am62x/optee/device-optee.mk
$(call optee-add-ta, vendor/ti/am62x/optee/ta/380231ac-fb99-47ad-a689-9e017eb6e78a.ta) # supp_plugin
$(call optee-add-all-xtest-ta, vendor/ti/am62x/optee/ta)
