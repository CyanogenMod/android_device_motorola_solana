PRODUCT_MAKEFILES := $(LOCAL_DIR)/full_solana.mk
ifeq ($(TARGET_PRODUCT),aokp_solana)
    PRODUCT_MAKEFILES += $(LOCAL_DIR)/aokp.mk
endif
