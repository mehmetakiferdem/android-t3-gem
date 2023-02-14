##########################################################
## define common variables, like TA_DEV_KIT_DIR         ##
##########################################################
TOP_ROOT_ABS := $(realpath $(TOP))

HOST_MAKE := prebuilts/build-tools/linux-x86/bin/make
COMPILE_LINE := $(HOST_MAKE)

# Output working directory
OPTEE_OUT_DIR ?= $(PRODUCT_OUT)/obj/PACKAGING/optee_intermediates
ABS_OPTEE_OUT_DIR := $(if $(filter /%,$(OUT_DIR)),$(OPTEE_OUT_DIR),$(TOP_ROOT_ABS)/$(OPTEE_OUT_DIR))
OPTEE_TA_OUT_DIR := $(OPTEE_OUT_DIR)/ta
ABS_OPTEE_TA_OUT_DIR := $(ABS_OPTEE_OUT_DIR)/ta

# Set so that OP-TEE clients can find the installed dev-kit, which
# depends on platform and its OP-TEE word-size.
OPTEE_OS_OUT_DIR := $(OPTEE_OUT_DIR)/arm-plat-k3
ABS_OPTEE_OS_OUT_DIR := $(ABS_OPTEE_OUT_DIR)/arm-plat-k3
TA_DEV_KIT_DIR := $(ABS_OPTEE_OS_OUT_DIR)/export-${OPTEE_TA_TARGETS}

# clang as default on Android
CROSS_COMPILE64 := aarch64-linux-android
CLANG_PATH := $(TOP_ROOT_ABS)/$(LLVM_PREBUILTS_BASE)/$(BUILD_OS)-x86/$(LLVM_PREBUILTS_VERSION)/bin
COMPILE_LINE := PATH=$(CLANG_PATH):$$PATH $(COMPILE_LINE) COMPILER=clang

# OP-TEE binary
OPTEE_BIN := $(OPTEE_OS_OUT_DIR)/core/tee.bin
$(OPTEE_BIN) : $(sort $(shell find -L $(OPTEE_OS_DIR)))

###########################################################
## define making rules for $(OPTEE_BIN) target, and add  ##
## condition check to make it only be defined once       ##
## even though this mk file might be included multiple   ##
## times. The process to generate $(OPTEE_BIN) file will ##
## generate the header files under                       ##
## $(TA_DEV_KIT_DIR)/host_include too.                   ##
## And the $(OPTEE_BIN) will be used as dependency for   ##
## other projects                                        ##
###########################################################

ifneq (true,$(BUILD_OPTEE_OS_DEFINED))
BUILD_OPTEE_OS_DEFINED := true
$(OPTEE_BIN):
	@echo "Start building ta_dev_kit..."
	$(COMPILE_LINE) \
		CROSS_COMPILE64=$(CROSS_COMPILE64) \
		-C $(TOP_ROOT_ABS)/$(OPTEE_OS_DIR) \
		O=$(ABS_OPTEE_OS_OUT_DIR) \
		CFG_BUILD_IN_TREE_TA=n \
		CFG_USER_TA_TARGETS=$(OPTEE_TA_TARGETS) \
		CFG_CORE_HEAP_SIZE=$(OPTEE_CFG_CORE_HEAP_SIZE) \
		CFG_ARM64_core=y \
		PLATFORM=k3 \
		$(OPTEE_EXTRA_FLAGS) \
		ta_dev_kit
	@echo "Finished building ta_dev_kit..."

endif
