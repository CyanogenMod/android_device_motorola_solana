ifeq ($(TARGET_DEVICE),solana)
PRODUCT_MAKEFILES := $(LOCAL_DIR)/full_solana.mk
ifeq ($(TARGET_PRODUCT),aokp_solana)
    PRODUCT_MAKEFILES += $(LOCAL_DIR)/aokp.mk
endif
ifeq ($(TARGET_PRODUCT),cna_solana)
    PRODUCT_MAKEFILES += $(LOCAL_DIR)/cna.mk
endif
ifeq ($(TARGET_PRODUCT),killrom_solana)
    PRODUCT_MAKEFILES += $(LOCAL_DIR)/killrom.mk
endif
endif
