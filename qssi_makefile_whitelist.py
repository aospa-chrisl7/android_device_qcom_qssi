# Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

FAILED_FILEPATHS_WHITELIST = {
    # NOTE: these files are from QSSI builds
    "vendor/qcom/opensource/audio-hal/primary-hal/configs/qssi/qssi.mk",
    "vendor/qcom/proprietary/android-perf/profiles.mk",
    "vendor/qcom/proprietary/chi-cdk/product.mk",
    "vendor/qcom/proprietary/commonsys/qrdplus/sva/products.mk",
    "vendor/qcom/proprietary/commonsys/voiceui/products.mk",
    "vendor/qcom/proprietary/mm-audio-internal/dolby/dax/device/dax2_common_hw.mk",
    "vendor/qcom/proprietary/prebuilt_ASAN/target/product/pineapple/prebuilt.mk",
    "vendor/qcom/proprietary/prebuilt_ASAN/target/product/qssi_64/prebuilt.mk",
    "vendor/qcom/proprietary/prebuilt_grease/target/common/prebuilt.mk",
    "vendor/qcom/proprietary/prebuilt_grease/target/product/pineapple/prebuilt.mk",
    "vendor/qcom/proprietary/prebuilt_grease/target/product/qssi_64/prebuilt.mk",
    "vendor/qcom/proprietary/prebuilt_HY11/target/common/prebuilt.mk",
    "vendor/qcom/proprietary/prebuilt_HY11/target/product/pineapple/prebuilt.mk",
    "vendor/qcom/proprietary/prebuilt_HY11/target/product/qssi_64/prebuilt.mk",
    "vendor/qcom/proprietary/prebuilt_HY22/target/common/prebuilt.mk",
    "vendor/qcom/proprietary/prebuilt_HY22/target/product/pineapple/prebuilt.mk",
    "vendor/qcom/proprietary/prebuilt_HY22/target/product/qssi_64/prebuilt.mk",
    "vendor/qcom/proprietary/qrdplus/China/ChinaMobile/products.mk",
    "vendor/qcom/proprietary/qrdplus/China/ChinaTelecom/products.mk",
    "vendor/qcom/proprietary/qrdplus/China/ChinaUnicom/products.mk",
    "vendor/qcom/proprietary/qrdplus/China/CTA/products.mk",
    "vendor/qcom/proprietary/qrdplus/Extension/products.mk",
    "vendor/qcom/proprietary/qrdplus/InternalUseOnly/DuerosSDK/products.mk",
    "vendor/qcom/proprietary/resource-overlay/overlay.mk",
}

SHELL_WHITELIST = {
    "device/qcom/sepolicy/SEPolicy.mk",
    "vendor/qcom/defs/product-defs/system/wigig-product.mk",
    "vendor/qcom/proprietary/common/create_files.mk",
    "vendor/qcom/proprietary/commonsys/openclwrapper/Android.mk",
}

RM_WHITELIST = {
    "vendor/qcom/proprietary/common/scripts/Android.mk",
}

LOCAL_COPY_HEADERS_WHITELIST = {}

DATETIME_WHITELIST = {}

TARGET_PRODUCT_WHITELIST = {
    "vendor/qcom/opensource/core-utils/build/AndroidBoardCommon.mk",
    "vendor/qcom/opensource/core-utils/build/build.sh",
    "vendor/qcom/opensource/core-utils/build/build_image_standalone.py",
}

RECURSIVE_WHITELIST = {}

KERNEL_WHITELIST = {}

FOREACH_WHITELIST = {
    "vendor/qcom/opensource/core-utils/build/utils.mk",
    "vendor/qcom/proprietary/common/config/device-vendor-qssi.mk",
    "vendor/qcom/proprietary/common/config/device-vendor-SDM845-pureAOSP.mk",
    "vendor/qcom/proprietary/common-noship/build/generate_extra_images_prop.mk",
}

MACRO_WHITELIST = {
    "device/qcom/sepolicy/SEPolicy.mk",
    "vendor/qcom/opensource/commonsys/display/config/display-product-commonsys.mk",
    "vendor/qcom/proprietary/common/config/device-vendor-qssi.mk",
    "vendor/qcom/proprietary/common/config/device-vendor-SDM845-pureAOSP.mk",
    "vendor/qcom/proprietary/common-noship/etc/device-vendor-noship.mk",
    "vendor/qcom/proprietary/common-noship/etc/device-vendor-noship-SDM845-pureAOSP.mk",
    "vendor/qcom/proprietary/common-noship/etc/device-vendor-qssi-noship.mk",
    "vendor/qcom/proprietary/commonsys/android-perf-noship/config/perf-product-system-proprietary.mk",
    "vendor/qcom/proprietary/commonsys/telephony-build/build/telephony_system_product.mk",
    "vendor/qcom/proprietary/commonsys-intf/data/dpm_system_product_noship.mk",
}

OVERRIDE_WHITELIST = {
    "device/qcom/qssi_64/qssi_64.mk",
    "device/qcom/qssi_64/qssi_64_whitelist.mk",
}

SOONG_WHITELIST = {
    "device/qcom/qssi_64/base.mk",
    "vendor/qcom/opensource/commonsys/display/config/display-product-commonsys.mk",
    "vendor/qcom/proprietary/commonsys-intf/bluetooth/bt-system-proprietary-product.mk",
    "vendor/qcom/opensource/commonsys-intf/display/config/display-product-system.mk",
}
