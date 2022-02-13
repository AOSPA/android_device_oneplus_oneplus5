#=============================================================================
# Copyright (c) 2020-2021 Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#
# Copyright (c) 2009-2012, 2014-2019, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#=============================================================================

function configure_zram_parameters() {
	MemTotalStr=`cat /proc/meminfo | grep MemTotal`
	MemTotal=${MemTotalStr:16:8}

	low_ram=`getprop ro.config.low_ram`

	# Zram disk - 75% for Go and < 2GB devices .
	# For >2GB Non-Go devices, size = 50% of RAM size. Limit the size to 4GB.
	# And enable lz4 zram compression for Go targets.

	let RamSizeGB="( $MemTotal / 1048576 ) + 1"
	diskSizeUnit=M
	if [ $RamSizeGB -le 2 ]; then
		let zRamSizeMB="( $RamSizeGB * 1024 ) * 3 / 4"
	else
		let zRamSizeMB="( $RamSizeGB * 1024 ) / 2"
	fi

	# use MB avoid 32 bit overflow
	if [ $zRamSizeMB -gt 4096 ]; then
		let zRamSizeMB=4096
	fi

	if [ "$low_ram" == "true" ]; then
		echo lz4 > /sys/block/zram0/comp_algorithm
	fi

	if [ -f /sys/block/zram0/disksize ]; then
		if [ -f /sys/block/zram0/use_dedup ]; then
			echo 1 > /sys/block/zram0/use_dedup
		fi
		echo "$zRamSizeMB""$diskSizeUnit" > /sys/block/zram0/disksize

		# ZRAM may use more memory than it saves if SLAB_STORE_USER
		# debug option is enabled.
		if [ -e /sys/kernel/slab/zs_handle ]; then
			echo 0 > /sys/kernel/slab/zs_handle/store_user
		fi
		if [ -e /sys/kernel/slab/zspage ]; then
			echo 0 > /sys/kernel/slab/zspage/store_user
		fi

		mkswap /dev/block/zram0
		swapon /dev/block/zram0 -p 32758
	fi
}

function configure_read_ahead_kb_values() {
	MemTotalStr=`cat /proc/meminfo | grep MemTotal`
	MemTotal=${MemTotalStr:16:8}

	dmpts=$(ls /sys/block/*/queue/read_ahead_kb | grep -e dm -e mmc)

	# Set 128 for <= 3GB &
	# set 512 for >= 4GB targets.
	if [ $MemTotal -le 3145728 ]; then
		ra_kb=128
	else
		ra_kb=512
	fi
	if [ -f /sys/block/mmcblk0/bdi/read_ahead_kb ]; then
		echo $ra_kb > /sys/block/mmcblk0/bdi/read_ahead_kb
	fi
	if [ -f /sys/block/mmcblk0rpmb/bdi/read_ahead_kb ]; then
		echo $ra_kb > /sys/block/mmcblk0rpmb/bdi/read_ahead_kb
	fi
	for dm in $dmpts; do
		echo $ra_kb > $dm
	done
}

function configure_memory_parameters() {
	# Set Memory parameters.
	#
	# Set per_process_reclaim tuning parameters
	# All targets will use vmpressure range 50-70,
	# All targets will use 512 pages swap size.
	#
	# Set Low memory killer minfree parameters
	# 32 bit Non-Go, all memory configurations will use 15K series
	# 32 bit Go, all memory configurations will use uLMK + Memcg
	# 64 bit will use Google default LMK series.
	#
	# Set ALMK parameters (usually above the highest minfree values)
	# vmpressure_file_min threshold is always set slightly higher
	# than LMK minfree's last bin value for all targets. It is calculated as
	# vmpressure_file_min = (last bin - second last bin ) + last bin
	#
	# Set allocstall_threshold to 0 for all targets.
	#

	configure_zram_parameters
	configure_read_ahead_kb_values
	echo 100 > /proc/sys/vm/swappiness
}

# disable thermal bcl hotplug to switch governor
echo 0 > /sys/module/msm_thermal/core_control/enabled

# online CPU0
echo 1 > /sys/devices/system/cpu/cpu0/online
# configure governor settings for little cluster
echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us
echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
# online CPU4
echo 1 > /sys/devices/system/cpu/cpu4/online
# configure governor settings for big cluster
echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
echo 0 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us
echo 0 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us

# bring all cores online
echo 1 > /sys/devices/system/cpu/cpu0/online
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu3/online
echo 1 > /sys/devices/system/cpu/cpu4/online
echo 1 > /sys/devices/system/cpu/cpu5/online
echo 1 > /sys/devices/system/cpu/cpu6/online
echo 1 > /sys/devices/system/cpu/cpu7/online

# re-enable thermal and BCL hotplug
echo 1 > /sys/module/msm_thermal/core_control/enabled

# Enable input boost configuration
# simon.ma+@2018/09/28,modify the input_boost_freq and input_boost_ms to make the anim smooth
echo "0:1036800 4:1056000" > /sys/module/cpu_boost/parameters/input_boost_freq
echo 450 > /sys/module/cpu_boost/parameters/input_boost_ms

# Enable bus-dcvs
for cpubw in /sys/devices/soc/*qcom,cpubw*/devfreq/*qcom,cpubw*
do
echo "bw_hwmon" > $cpubw/governor
echo 50 > $cpubw/polling_interval
echo 1525 > $cpubw/min_freq
echo "3143 5859 11863 13763" > $cpubw/bw_hwmon/mbps_zones
echo 4 > $cpubw/bw_hwmon/sample_ms
echo 34 > $cpubw/bw_hwmon/io_percent
echo 20 > $cpubw/bw_hwmon/hist_memory
echo 10 > $cpubw/bw_hwmon/hyst_length
echo 0 > $cpubw/bw_hwmon/guard_band_mbps
echo 250 > $cpubw/bw_hwmon/up_scale
echo 1600 > $cpubw/bw_hwmon/idle_mbps
done

for memlat in /sys/devices/soc/*qcom,memlat-cpu*/devfreq/*qcom,memlat-cpu*
do
echo "mem_latency" > $memlat/governor
echo 10 > $memlat/polling_interval
echo 400 > $memlat/mem_latency/ratio_ceil
done

echo "cpufreq" > /sys/devices/soc/soc:qcom,mincpubw/devfreq/soc:qcom,mincpubw/governor

if [ -f /sys/devices/soc0/soc_id ]; then
soc_id=`cat /sys/devices/soc0/soc_id`
else
soc_id=`cat /sys/devices/system/soc/soc0/id`
fi

if [ -f /sys/devices/soc0/hw_platform ]; then
hw_platform=`cat /sys/devices/soc0/hw_platform`
else
hw_platform=`cat /sys/devices/system/soc/soc0/hw_platform`
fi

if [ -f /sys/devices/soc0/platform_version ]; then
platform_version=`cat /sys/devices/soc0/platform_version`
platform_major_version=$((10#${platform_version}>>16))
fi

if [ -f /sys/devices/soc0/platform_subtype_id ]; then
platform_subtype_id=`cat /sys/devices/soc0/platform_subtype_id`
fi

# enable LPM
echo N > /sys/module/lpm_levels/system/pwr/cpu0/ret/idle_enabled
echo N > /sys/module/lpm_levels/system/pwr/cpu1/ret/idle_enabled
echo N > /sys/module/lpm_levels/system/pwr/cpu2/ret/idle_enabled
echo N > /sys/module/lpm_levels/system/pwr/cpu3/ret/idle_enabled
echo N > /sys/module/lpm_levels/system/perf/cpu4/ret/idle_enabled
echo N > /sys/module/lpm_levels/system/perf/cpu5/ret/idle_enabled
echo N > /sys/module/lpm_levels/system/perf/cpu6/ret/idle_enabled
echo N > /sys/module/lpm_levels/system/perf/cpu7/ret/idle_enabled
echo N > /sys/module/lpm_levels/system/pwr/pwr-l2-dynret/idle_enabled
echo N > /sys/module/lpm_levels/system/pwr/pwr-l2-ret/idle_enabled
echo N > /sys/module/lpm_levels/system/perf/perf-l2-dynret/idle_enabled
echo N > /sys/module/lpm_levels/system/perf/perf-l2-ret/idle_enabled
echo N > /sys/module/lpm_levels/parameters/sleep_disabled

# Turn off scheduler boost at the end
echo 0 > /proc/sys/kernel/sched_boost

# Set Memory parameters
configure_memory_parameters

# Let kernel know our image version/variant/crm_version
if [ -f /sys/devices/soc0/select_image ]; then
	image_version="10:"
	image_version+=`getprop ro.build.id`
	image_version+=":"
	image_version+=`getprop ro.build.version.incremental`
	image_variant=`getprop ro.product.name`
	image_variant+="-"
	image_variant+=`getprop ro.build.type`
	oem_version=`getprop ro.build.version.codename`
	echo 10 > /sys/devices/soc0/select_image
	echo $image_version > /sys/devices/soc0/image_version
	echo $image_variant > /sys/devices/soc0/image_variant
	echo $oem_version > /sys/devices/soc0/image_crm_version
fi

# Change console log level as per console config property
console_config=`getprop persist.vendor.console.silent.config`
case "$console_config" in
	"1")
		echo "Enable console config to $console_config"
		echo 0 > /proc/sys/kernel/printk
	;;
	*)
		echo "Enable console config to $console_config"
	;;
esac

setprop vendor.post_boot.parsed 1
