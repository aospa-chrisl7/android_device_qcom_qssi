# create symlink system/lib/modules -> system_dlkm/lib/modules
ifeq ($(CREATE_SYSTEM_DLKM_SYMLINK),true)
$(call symlink-file,,/system_dlkm/lib/modules,$(TARGET_OUT)/lib/modules)
ALL_DEFAULT_INSTALLED_MODULES += $(TARGET_OUT)/lib/modules
endif
