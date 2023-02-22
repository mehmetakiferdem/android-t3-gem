
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=1m \
    dalvik.vm.heapgrowthlimit=192m \
    dalvik.vm.heapsize=384m \
    dalvik.vm.heaptargetutilization=0.90 \
    dalvik.vm.heapminfree=512k \
    dalvik.vm.heapmaxfree=2m \
    dalvik.vm.usejit=true \
    ro.lmk.medium=700 \
    ro.lmk.critical_upgrade=true \
    ro.lmk.upgrade_pressure=40 \
    ro.lmk.downgrade_pressure=60 \
    ro.lmk.kill_heaviest_task=false \
    pm.dexopt.downgrade_after_inactive_days=10 \
    pm.dexopt.shared=quicken

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

# gatekeeper
$(call optee-add-ta, vendor/ti/am62x/optee/ta/4d573443-6a56-4272-ac6f-2425af9ef9bb.ta)
# keymaster
$(call optee-add-ta, vendor/ti/am62x/optee/ta/dba51a17-0563-11e7-93b1-6fa7b0071a51.ta)
