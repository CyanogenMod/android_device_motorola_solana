/*
 * unreg_pvr - remove PVR driver / device from kernel so that we can load a new one
 *
 * hooking taken from "n - for testing kernel function hooking" by Nothize
 * require symsearch module by Skrilaz
 *
 */

#include <linux/module.h>
#include <linux/device.h>
#include <asm/uaccess.h>

#include "hook.h"

#define MODULE_TAG "pvrkill"

/* Hooked Function */
void PVRCore_Cleanup(void) {
printk(KERN_INFO MODULE_TAG": before\n");
//    HOOK_INVOKE(PVRCore_Cleanup);
printk(KERN_INFO MODULE_TAG": after\n");
}

struct hook_info g_hi[] = {
    HOOK_INIT(PVRCore_Cleanup),
    HOOK_INIT_END
};

static int __init pvrkill_init(void) {
    hook_init();
    HOOK_INVOKE(PVRCore_Cleanup);
    return 0;
}

static void __exit pvrkill_exit(void) {
    hook_exit();
}

module_init(pvrkill_init);
module_exit(pvrkill_exit);

MODULE_ALIAS(MODULE_TAG);
MODULE_VERSION("1.0");
MODULE_DESCRIPTION("Hook PVRCore_Cleanup -- source by example based on gpio-fix by Tanguy Pruvot, CyanogenDefy");
MODULE_AUTHOR("Hashcode");
MODULE_LICENSE("GPL");


