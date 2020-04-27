/*
   Copyright (c) 2016, The CyanogenMod Project

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
   WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
   ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
   IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdlib.h>
#include <android-base/properties.h>
#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>
#include <stdio.h>
#include <sys/system_properties.h>

#include "vendor_init.h"
#include "property_service.h"

#define PROP_VARIANT "ro.product.vendor.device"
using android::base::GetProperty;

void property_override(char const prop[], char const value[])
{
	prop_info *pi;

	pi = (prop_info*) __system_property_find(prop);
	if (pi)
		__system_property_update(pi, value, strlen(value));
	else
		__system_property_add(prop, strlen(prop), value, strlen(value));
}

void property_override_dual(char const system_prop[], char const vendor_prop[], const char value[])
{
	property_override(system_prop, value);
	property_override(vendor_prop, value);
}


void vendor_load_properties()
{
	std::string variant = GetProperty(PROP_VARIANT, "");
	if (variant == "OnePlus5") {
		property_override("ro.product.system.device", "oneplus5");
		property_override("ro.product.system.model", "OnePlus 5");
		property_override("ro.product.device", "OnePlus5");
		property_override("ro.system.build.fingerprint", "OnePlus/OnePlus5/OnePlus5:10/QKQ1.191014.012/2005122320:user/release-keys");
	} else if (variant == "OnePlus5T") {
		property_override("ro.product.system.device", "oneplus5t");
		property_override("ro.product.system.model", "OnePlus 5T");
		property_override("ro.product.device", "OnePlus5T");
		property_override("ro.system.build.fingerprint", "OnePlus/OnePlus5T/OnePlus5T:10/QKQ1.191014.012/2005130017:user/release-keys");
	}

	// Common Properties
	// Dalvik
	property_override_dual("dalvik.vm.heapstartsize", "dalvik.vm.heapstartsize", "16m");
	property_override_dual("dalvik.vm.heapgrowthlimit", "dalvik.vm.heapgrowthlimit", "256m");
	property_override_dual("dalvik.vm.heapsize", "dalvik.vm.heapsize", "512m");
	property_override_dual("dalvik.vm.heaptargetutilization", "dalvik.vm.heaptargetutilization", "0.5");
	property_override_dual("dalvik.vm.heapminfree", "dalvik.vm.heapminfree", "8m");
	property_override_dual("dalvik.vm.heapmaxfree", "dalvik.vm.heapmaxfree", "32m");
}
