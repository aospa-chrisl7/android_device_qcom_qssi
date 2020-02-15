LOCAL_PATH := $(call my-dir)

#----------------------------------------------------------------------
# Host compiler configs
#----------------------------------------------------------------------
SOURCE_ROOT := $(shell pwd)
TARGET_HOST_COMPILER_PREFIX_OVERRIDE := prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/bin/x86_64-linux-
TARGET_HOST_CC_OVERRIDE := $(SOONG_LLVM_PREBUILTS_PATH)/clang
TARGET_HOST_CXX_OVERRIDE := $(TARGET_HOST_COMPILER_PREFIX_OVERRIDE)g++
TARGET_HOST_AR_OVERRIDE := $(TARGET_HOST_COMPILER_PREFIX_OVERRIDE)ar
TARGET_HOST_LD_OVERRIDE := $(TARGET_HOST_COMPILER_PREFIX_OVERRIDE)ld

#----------------------------------------------------------------------
# Compile (L)ittle (K)ernel bootloader and the nandwrite utility
#----------------------------------------------------------------------
ifneq ($(strip $(TARGET_NO_BOOTLOADER)),true)

# Compile
include bootable/bootloader/edk2/AndroidBoot.mk

$(INSTALLED_BOOTLOADER_MODULE): $(TARGET_EMMC_BOOTLOADER) | $(ACP)
	$(transform-prebuilt-to-target)
$(BUILT_TARGET_FILES_PACKAGE): $(INSTALLED_BOOTLOADER_MODULE)

droidcore: $(INSTALLED_BOOTLOADER_MODULE)
endif

#----------------------------------------------------------------------
# Compile Linux Kernel
#----------------------------------------------------------------------
ifneq ($(wildcard device/qcom/kernelscripts/kernel_definitions.mk),)
include device/qcom/kernelscripts/kernel_definitions.mk
else
DTC := $(HOST_OUT_EXECUTABLES)/dtc$(HOST_EXECUTABLE_SUFFIX)
UFDT_APPLY_OVERLAY := $(HOST_OUT_EXECUTABLES)/ufdt_apply_overlay$(HOST_EXECUTABLE_SUFFIX)

TARGET_KERNEL_MAKE_ENV := DTC_EXT=$(SOURCE_ROOT)/$(DTC)
TARGET_KERNEL_MAKE_ENV += DTC_OVERLAY_TEST_EXT=$(SOURCE_ROOT)/$(UFDT_APPLY_OVERLAY)
TARGET_KERNEL_MAKE_ENV += CONFIG_BUILD_ARM64_DT_OVERLAY=y
TARGET_KERNEL_MAKE_ENV += HOSTCC=$(SOURCE_ROOT)/$(TARGET_HOST_CC_OVERRIDE)
TARGET_KERNEL_MAKE_ENV += HOSTAR=$(SOURCE_ROOT)/$(TARGET_HOST_AR_OVERRIDE)
TARGET_KERNEL_MAKE_ENV += HOSTLD=$(SOURCE_ROOT)/$(TARGET_HOST_LD_OVERRIDE)
ifeq ($(TARGET_USES_NEW_ION), false)
TARGET_KERNEL_MAKE_ENV += HOSTCFLAGS="-I/usr/include -I/usr/include/x86_64-linux-gnu -L/usr/lib -L/usr/lib/x86_64-linux-gnu -fuse-ld=lld"
else
TARGET_KERNEL_MAKE_ENV += HOSTCFLAGS="-I$(SOURCE_ROOT)/kernel/msm-$(TARGET_KERNEL_VERSION)/include/uapi -I/usr/include -I/usr/include/x86_64-linux-gnu -L/usr/lib -L/usr/lib/x86_64-linux-gnu -fuse-ld=lld"
endif
TARGET_KERNEL_MAKE_ENV += HOSTLDFLAGS="-L/usr/lib -L/usr/lib/x86_64-linux-gnu -fuse-ld=lld"

KERNEL_LLVM_BIN := $(lastword $(sort $(wildcard $(SOURCE_ROOT)/$(LLVM_PREBUILTS_BASE)/$(BUILD_OS)-x86/clang-4*)))/bin/clang

$(warning Kernel source tree path is: $(TARGET_KERNEL_SOURCE))
$(warning Kernel version  is: $(TARGET_KERNEL_VERSION))
$(warning Kernel version  is: $(KERNEL_DEFCONFIG))
include $(TARGET_KERNEL_SOURCE)/AndroidKernel.mk
$(TARGET_PREBUILT_KERNEL): $(DTC) $(UFDT_APPLY_OVERLAY)

$(INSTALLED_KERNEL_TARGET): $(TARGET_PREBUILT_KERNEL) | $(ACP)
	$(transform-prebuilt-to-target)
endif

#----------------------------------------------------------------------
# Copy additional target-specific files
#----------------------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE       := vold.fstab
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)


include $(CLEAR_VARS)
LOCAL_MODULE       := gpio-keys.kl
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_KEYLAYOUT)
include $(BUILD_PREBUILT)

# Build the buildtools.zip package.
# It is a package consisting of build tools (like java jdk, build.sh, test-keys),
# that is further useful for post-make standalone image creation (like for super.img).
INTERNAL_BUILDTOOLS_PACKAGE_FILES := \
  build/make/target/product/security \
  vendor/qcom/opensource/core-utils/build/build.sh \
  vendor/qcom/opensource/core-utils/build/build_image_standalone.py

# Pick the default java jdk used by build system
INTERNAL_BUILDTOOLS_PACKAGE_JAVA_PREBUILT := $(JAVA_HOME)

BUILT_BUILDTOOLS_PACKAGE_NAME := buildtools.zip
BUILT_BUILDTOOLS_PACKAGE := $(PRODUCT_OUT)/$(BUILT_BUILDTOOLS_PACKAGE_NAME)
$(BUILT_BUILDTOOLS_PACKAGE): PRIVATE_ZIP_ROOT := $(call intermediates-dir-for,PACKAGING,buildtools)/buildtools
$(BUILT_BUILDTOOLS_PACKAGE): PRIVATE_BUILDTOOLS_PACKAGE_FILES := $(INTERNAL_BUILDTOOLS_PACKAGE_FILES)
$(BUILT_BUILDTOOLS_PACKAGE): PRIVATE_BUILDTOOLS_PACKAGE_FILES_JAVA_PREBUILT := $(INTERNAL_BUILDTOOLS_PACKAGE_JAVA_PREBUILT)
$(BUILT_BUILDTOOLS_PACKAGE): $(SOONG_ZIP)
	@echo "Package build tools: $@"
	rm -rf $@ $(PRIVATE_ZIP_ROOT)
	mkdir -p $(dir $@) $(PRIVATE_ZIP_ROOT)
	$(call copy-files-with-structure,$(PRIVATE_BUILDTOOLS_PACKAGE_FILES),,$(PRIVATE_ZIP_ROOT))
	$(call copy-files-with-structure,$(PRIVATE_BUILDTOOLS_PACKAGE_FILES_JAVA_PREBUILT),$(SOURCE_ROOT)/,$(PRIVATE_ZIP_ROOT))
	echo "$(patsubst $(SOURCE_ROOT)/%,%,$(PRIVATE_BUILDTOOLS_PACKAGE_FILES_JAVA_PREBUILT))" > $(PRIVATE_ZIP_ROOT)/JAVA_HOME.txt
	$(SOONG_ZIP) -o $@ -C $(PRIVATE_ZIP_ROOT) -D $(PRIVATE_ZIP_ROOT)

droidcore: $(BUILT_BUILDTOOLS_PACKAGE)
$(call dist-for-goals,droidcore,$(BUILT_BUILDTOOLS_PACKAGE):buildtools/$(BUILT_BUILDTOOLS_PACKAGE_NAME))
# -- end buildtools.zip.

#----------------------------------------------------------------------
# Configs common to AndroidBoard.mk for all targets
#----------------------------------------------------------------------
include vendor/qcom/opensource/core-utils/build/AndroidBoardCommon.mk

#create firmware directory for qssi
$(shell  mkdir -p $(TARGET_OUT_VENDOR)/firmware)

# override default make with prebuilt make path (if any)
ifneq (, $(wildcard $(shell pwd)/prebuilts/build-tools/linux-x86/bin/make))
   MAKE := $(shell pwd)/prebuilts/build-tools/linux-x86/bin/$(MAKE)
endif
