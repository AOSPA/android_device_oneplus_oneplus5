#!/system/bin/sh
# Copyright (c) 2014-2017, The Linux Foundation. All rights reserved.
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
#

HERE=/system/etc
source $HERE/init.qcom.debug-sdm660.sh
# function to enable ftrace events to CoreSight STM
enable_stm_events()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi
    # bail out if coresight isn't present
    if [ ! -d /sys/bus/coresight ]
    then
        return
    fi
    #bail out if coresight-stm device node isn't present
    if [ ! -e /dev/coresight-stm ]
    then
        return
    fi
    # bail out if ftrace events aren't present
    if [ ! -d /sys/kernel/debug/tracing/events ]
    then
        return
    fi

    echo 0x2000000 > /sys/bus/coresight/devices/coresight-tmc-etr/mem_size
    echo 1 > /sys/bus/coresight/devices/coresight-tmc-etr/curr_sink
    echo 1 > /sys/bus/coresight/devices/coresight-stm/enable
    echo 1 > /sys/kernel/debug/tracing/tracing_on
    echo 0 > /sys/bus/coresight/devices/coresight-stm/hwevent_enable
    # timer
    echo 1 > /sys/kernel/debug/tracing/events/timer/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/filter
    echo 1 > /sys/kernel/debug/tracing/events/timer/timer_cancel/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/timer_expire_entry/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/timer_expire_exit/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/timer_init/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/timer_start/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/tick_stop/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_cancel/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_expire_entry/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_expire_exit/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_init/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_start/enable
    #enble FTRACE for softirq events
    echo 1 > /sys/kernel/debug/tracing/events/irq/enable
    echo 1 > /sys/kernel/debug/tracing/events/irq/filter
    echo 1 > /sys/kernel/debug/tracing/events/irq/softirq_entry/enable
    echo 1 > /sys/kernel/debug/tracing/events/irq/softirq_exit/enable
    echo 1 > /sys/kernel/debug/tracing/events/irq/softirq_raise/enable
    #enble FTRACE for Workqueue events
    echo 1 > /sys/kernel/debug/tracing/events/workqueue/enable
    echo 1 > /sys/kernel/debug/tracing/events/workqueue/filter
    echo 1 > /sys/kernel/debug/tracing/events/workqueue/workqueue_activate_work/enable
    echo 1 > /sys/kernel/debug/tracing/events/workqueue/workqueue_execute_end/enable
    echo 1 > /sys/kernel/debug/tracing/events/workqueue/workqueue_execute_start/enable
    echo 1 > /sys/kernel/debug/tracing/events/workqueue/workqueue_queue_work/enable
    # schedular
    echo 1 > /sys/kernel/debug/tracing/events/sched/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/filter
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_cpu_hotplug/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_cpu_load/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_enq_deq_task/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_kthread_stop_ret/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_kthread_stop/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_load_balance/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_migrate_task/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_pi_setprio/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_process_exec/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_process_exit/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_process_fork/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_process_free/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_process_wait/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_stat_blocked/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_stat_iowait/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_stat_runtime/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_stat_sleep/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_stat_wait/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_switch/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_task_load/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_update_history/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_update_task_ravg/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wait_task/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wakeup/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wakeup_new/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_get_busy/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_get_nr_running_avg/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_reset_all_window_stats/enable
    # sound
    echo 1 > /sys/kernel/debug/tracing/events/asoc/snd_soc_reg_read/enable
    echo 1 > /sys/kernel/debug/tracing/events/asoc/snd_soc_reg_write/enable
    # mdp
    echo 1 > /sys/kernel/debug/tracing/events/mdss/mdp_video_underrun_done/enable
    # video
    echo 1 > /sys/kernel/debug/tracing/events/msm_vidc/enable
    # clock
    echo 1 > /sys/kernel/debug/tracing/events/power/clock_set_rate/enable
    # regulator
    echo 1 > /sys/kernel/debug/tracing/events/regulator/enable
    # power
    echo 1 > /sys/kernel/debug/tracing/events/msm_low_power/enable
    #thermal
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_pre_core_offline/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_post_core_offline/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_pre_core_online/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_post_core_online/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_pre_frequency_mit/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_post_frequency_mit/enable
}

# Function MSMCOBALT DCC configuration
enable_msm8998_dcc_config()
{
    DCC_PATH="/sys/bus/platform/devices/10b3000.dcc"
    if [ ! -d $DCC_PATH ]; then
        echo "DCC don't exist on this build."
        return
    fi

    echo  0 > $DCC_PATH/enable
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo  1 > $DCC_PATH/config_reset

    #OSM WDOG
    echo 0x179C1C00 37 > $DCC_PATH/config
    echo 0x179C3C00 37 > $DCC_PATH/config
    #APM
    echo 0x179D0000 1 > $DCC_PATH/config
    echo 0x179D000C 1 > $DCC_PATH/config
    echo 0x179D0018 1 > $DCC_PATH/config
    #L2_SAW4_PMIC_STS
    echo 0x17912C18 1 > $DCC_PATH/config
    echo 0x17812C18 1 > $DCC_PATH/config
    #CPRH_STATUS
    echo 0x179CBAA4 1 > $DCC_PATH/config
    echo 0x179C7AA4 1 > $DCC_PATH/config

    # default configuration
    #SPM registers
    echo 0x17989000 > $DCC_PATH/config
    echo 0x17989C0C > $DCC_PATH/config
    echo 0x17988064 > $DCC_PATH/config
    echo 0x17999000 > $DCC_PATH/config
    echo 0x17999C0C > $DCC_PATH/config
    echo 0x17998064 > $DCC_PATH/config
    echo 0x179A9000 > $DCC_PATH/config
    echo 0x179A9C0C > $DCC_PATH/config
    echo 0x179A8064 > $DCC_PATH/config
    echo 0x179B9000 > $DCC_PATH/config
    echo 0x179B9C0C > $DCC_PATH/config
    echo 0x179B8064 > $DCC_PATH/config
    echo 0x17912000 > $DCC_PATH/config
    echo 0x17912C0C > $DCC_PATH/config
    echo 0x17911210 > $DCC_PATH/config
    echo 0x17911290 > $DCC_PATH/config
    echo 0x17911218 > $DCC_PATH/config
    echo 0x17889000 > $DCC_PATH/config
    echo 0x17889C0C > $DCC_PATH/config
    echo 0x17888064 > $DCC_PATH/config
    echo 0x17899000 > $DCC_PATH/config
    echo 0x17899C0C > $DCC_PATH/config
    echo 0x17898064 > $DCC_PATH/config
    echo 0x178A9000 > $DCC_PATH/config
    echo 0x178A9C0C > $DCC_PATH/config
    echo 0x178A8064 > $DCC_PATH/config
    echo 0x178B9000 > $DCC_PATH/config
    echo 0x178B9C0C > $DCC_PATH/config
    echo 0x178B8064 > $DCC_PATH/config
    echo 0x17812000 > $DCC_PATH/config
    echo 0x17812C0C > $DCC_PATH/config
    echo 0x17811210 > $DCC_PATH/config
    echo 0x17811290 > $DCC_PATH/config
    echo 0x17811218 > $DCC_PATH/config
    echo 0x179D2000 > $DCC_PATH/config
    echo 0x179D2C0C > $DCC_PATH/config
    echo 0x17904008 > $DCC_PATH/config
    echo 0x1790400C > $DCC_PATH/config
    echo 0x17904010 > $DCC_PATH/config
    echo 0x17904014 > $DCC_PATH/config

    # CCI ACE / Stalled Transaction
    echo 0x179082B0 > $DCC_PATH/config

    # 8 times, same register
    echo 0x17901000 > $DCC_PATH/config
    echo 0x17901000 > $DCC_PATH/config
    echo 0x17901000 > $DCC_PATH/config
    echo 0x17901000 > $DCC_PATH/config
    echo 0x17901000 > $DCC_PATH/config
    echo 0x17901000 > $DCC_PATH/config
    echo 0x17901000 > $DCC_PATH/config
    echo 0x17901000 > $DCC_PATH/config

    echo  1 > $DCC_PATH/enable
}

# Function MSMFALCON DCC configuration
enable_sdm660_dcc_config()
{
    DCC_PATH="/sys/bus/platform/devices/10b3000.dcc"
    if [ ! -d $DCC_PATH ]; then
        echo "DCC don't exist on this build."
        return
    fi

    echo  0 > $DCC_PATH/enable
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo  1 > $DCC_PATH/config_reset

    #OSM WDOG
    echo 0x179C1C00 37 > $DCC_PATH/config
    echo 0x179C3C00 37 > $DCC_PATH/config
    #APM
    echo 0x179D0000 1 > $DCC_PATH/config
    echo 0x179D000C 1 > $DCC_PATH/config
    echo 0x179D0018 1 > $DCC_PATH/config
    #L2_SAW4_PMIC_STS
    echo 0x17912C18 1 > $DCC_PATH/config
    echo 0x17812C18 1 > $DCC_PATH/config
    #CPRH_STATUS
    echo 0x179C4000 1 > $DCC_PATH/config
    echo 0x179C8000 1 > $DCC_PATH/config
    echo 0x179CBAA4 1 > $DCC_PATH/config
    echo 0x179C7AA4 1 > $DCC_PATH/config

    #APCS_ALIAS0_APSS_ACS
    echo 0x17988004 > $DCC_PATH/config    #CPU_PWR_CTL
    echo 0x17988008 > $DCC_PATH/config    #APC_PWR_STATUS
    echo 0x17988064 > $DCC_PATH/config    #SPM_QCHANNEL_CFG
    #APCS_ALIAS0_SAW4_1_1_SPM
    echo 0x17989000 > $DCC_PATH/config    #SPM_CTL
    #APCS_ALIAS0_SAW4_1_1_STS
    echo 0x17989C0C > $DCC_PATH/config    #SPM_STS
    echo 0x17989C10 > $DCC_PATH/config    #SPM_STS2
    echo 0x17989C20 > $DCC_PATH/config    #SPM_STS3
    echo 0x17989C18 > $DCC_PATH/config    #PMIC_STS

    #APCS_ALIAS1_APSS_ACS
    echo 0x17998004 > $DCC_PATH/config    #CPU_PWR_CTL
    echo 0x17998008 > $DCC_PATH/config    #APC_PWR_STATUS
    echo 0x17998064 > $DCC_PATH/config    #SPM_QCHANNEL_CFG
    #APCS_ALIAS1_SAW4_1_1_SPM
    echo 0x17999000 > $DCC_PATH/config    #SPM_CTL
    #APCS_ALIAS1_SAW4_1_1_STS
    echo 0x17999C0C > $DCC_PATH/config    #SPM_STS
    echo 0x17999C10 > $DCC_PATH/config    #SPM_STS2
    echo 0x17999C20 > $DCC_PATH/config    #SPM_STS3

    #APCS_ALIAS2_APSS_ACS
    echo 0x179A8004 > $DCC_PATH/config    #CPU_PWR_CTL
    echo 0x179A8008 > $DCC_PATH/config    #APC_PWR_STATUS
    echo 0x179A8064 > $DCC_PATH/config    #SPM_QCHANNEL_CFG
    #APCS_ALIAS2_SAW4_1_1_SPM
    echo 0x179A9000 > $DCC_PATH/config    #SPM_CTL
    #APCS_ALIAS2_SAW4_1_1_STS
    echo 0x179A9C0C > $DCC_PATH/config    #SPM_STS
    echo 0x179A9C10 > $DCC_PATH/config    #SPM_STS2
    echo 0x179A9C20 > $DCC_PATH/config    #SPM_STS3

    #APCS_ALIAS3_APSS_ACS
    echo 0x179B8004 > $DCC_PATH/config    #CPU_PWR_CTL
    echo 0x179B8008 > $DCC_PATH/config    #APC_PWR_STATUS
    echo 0x179B8064 > $DCC_PATH/config    #SPM_QCHANNEL_CFG
    #APCS_ALIAS3_SAW4_1_1_SPM
    echo 0x179B9000 > $DCC_PATH/config    #SPM_CTL
    #APCS_ALIAS3_SAW4_1_1_STS
    echo 0x179B9C0C > $DCC_PATH/config    #SPM_STS
    echo 0x179B9C10 > $DCC_PATH/config    #SPM_STS2
    echo 0x179B9C20 > $DCC_PATH/config    #SPM_STS3

    #APCS_ALIAS0_APSS_GLB
    echo 0x17911014 > $DCC_PATH/config    #L2_PWR_CTL
    echo 0x17911018 > $DCC_PATH/config    #L2_PWR_STATUS
    echo 0x17911210 > $DCC_PATH/config    #L2_SPM_QCHANNEL_CFG
    echo 0x17911218 > $DCC_PATH/config    #L2_FLUSH_CTL
    echo 0x17911234 > $DCC_PATH/config    #L2_FLUSH_STS
    echo 0x17911290 > $DCC_PATH/config    #DX_FSM_STATUS
    #APCLUS0_L2_SAW4_1_1_SPM
    echo 0x17912000 > $DCC_PATH/config    #SPM_CTL
    echo 0x17912004 > $DCC_PATH/config    #SPM_DLY
    echo 0x1791200C > $DCC_PATH/config    #SPM_CFG
    #APCLUS0_L2_SAW4_1_1_STS
    echo 0x17912C0C > $DCC_PATH/config    #SPM_STS
    echo 0x17912C10 > $DCC_PATH/config    #SPM_STS2
    echo 0x17912C20 > $DCC_PATH/config    #SPM_STS3
    echo 0x17912C18 > $DCC_PATH/config    #PMIC_STS


    #APCS_ALIAS4_APSS_ACS
    echo 0x17888004 > $DCC_PATH/config    #CPU_PWR_CTL
    echo 0x17888008 > $DCC_PATH/config    #APC_PWR_STATUS
    echo 0x17888064 > $DCC_PATH/config    #SPM_QCHANNEL_CFG
    #APCS_ALIAS4_SAW4_1_1_SPM
    echo 0x17889000 > $DCC_PATH/config    #SPM_CTL
    #APCS_ALIAS4_SAW4_1_1_STS
    echo 0x17889C0C > $DCC_PATH/config    #SPM_STS
    echo 0x17889C10 > $DCC_PATH/config    #SPM_STS2
    echo 0x17889C20 > $DCC_PATH/config    #SPM_STS3
    echo 0x17889C18 > $DCC_PATH/config    #PMIC_STS

    #APCS_ALIAS5_APSS_ACS
    echo 0x17898004 > $DCC_PATH/config    #CPU_PWR_CTL
    echo 0x17898008 > $DCC_PATH/config    #APC_PWR_STATUS
    echo 0x17898064 > $DCC_PATH/config    #SPM_QCHANNEL_CFG
    #APCS_ALIAS5_SAW4_1_1_SPM
    echo 0x17899000 > $DCC_PATH/config    #SPM_CTL
    #APCS_ALIAS5_SAW4_1_1_STS
    echo 0x17899C0C > $DCC_PATH/config    #SPM_STS
    echo 0x17899C10 > $DCC_PATH/config    #SPM_STS2
    echo 0x17899C20 > $DCC_PATH/config    #SPM_STS3

    #APCS_ALIAS6_APSS_ACS
    echo 0x178A8004 > $DCC_PATH/config    #CPU_PWR_CTL
    echo 0x178A8008 > $DCC_PATH/config    #APC_PWR_STATUS
    echo 0x178A8064 > $DCC_PATH/config    #SPM_QCHANNEL_CFG
    #APCS_ALIAS6_SAW4_1_1_SPM
    echo 0x178A9000 > $DCC_PATH/config    #SPM_CTL
    #APCS_ALIAS6_SAW4_1_1_STS
    echo 0x178A9C0C > $DCC_PATH/config    #SPM_STS
    echo 0x178A9C10 > $DCC_PATH/config    #SPM_STS2
    echo 0x178A9C20 > $DCC_PATH/config    #SPM_STS3

    #APCS_ALIAS7_APSS_ACS
    echo 0x178B8004 > $DCC_PATH/config    #CPU_PWR_CTL
    echo 0x178B8008 > $DCC_PATH/config    #APC_PWR_STATUS
    echo 0x178B8064 > $DCC_PATH/config    #SPM_QCHANNEL_CFG
    #APCS_ALIAS7_SAW4_1_1_SPM
    echo 0x178B9000 > $DCC_PATH/config    #SPM_CTL
    #APCS_ALIAS7_SAW4_1_1_STS
    echo 0x178B9C0C > $DCC_PATH/config    #SPM_STS
    echo 0x178B9C10 > $DCC_PATH/config    #SPM_STS2
    echo 0x178B9C20 > $DCC_PATH/config    #SPM_STS3

    #APCS_ALIAS1_APSS_GLB
    echo 0x17811014 > $DCC_PATH/config    #L2_PWR_CTL
    echo 0x17811018 > $DCC_PATH/config    #L2_PWR_STATUS
    echo 0x17811210 > $DCC_PATH/config    #L2_SPM_QCHANNEL_CFG
    echo 0x17811218 > $DCC_PATH/config    #L2_FLUSH_CTL
    echo 0x17811234 > $DCC_PATH/config    #L2_FLUSH_STS
    echo 0x17811290 > $DCC_PATH/config    #DX_FSM_STATUS
    #APCLUS1_L2_SAW4_1_1_SPM
    echo 0x17812000 > $DCC_PATH/config    #SPM_CTL
    echo 0x17812004 > $DCC_PATH/config    #SPM_DLY
    echo 0x1781200C > $DCC_PATH/config    #SPM_CFG
    #APCLUS1_L2_SAW4_1_1_STS
    echo 0x17812C0C > $DCC_PATH/config    #SPM_STS
    echo 0x17812C10 > $DCC_PATH/config    #SPM_STS2
    echo 0x17812C20 > $DCC_PATH/config    #SPM_STS3
    echo 0x17812C18 > $DCC_PATH/config    #PMIC_STS

    #APCS_CCI_GLADIATOR
    echo 0x17900008 > $DCC_PATH/config    #APCS_CCI_GLADIATOR_MAIN_CRIXUS_CFGIO
    echo 0x17900078 > $DCC_PATH/config    #APCS_CCI_GLADIATOR_MAIN_CRIXUS_CFGDUT
    echo 0x17901014 > $DCC_PATH/config    #APCS_CCI_GLADIATOR_MAIN_CRIXUS_ERRVLD
    echo 0x17901018 > $DCC_PATH/config    #APCS_CCI_GLADIATOR_MAIN_CRIXUS_ERRCLR
    echo 0x1790101C > $DCC_PATH/config    #APCS_CCI_GLADIATOR_MAIN_CRIXUS_ERRLOG0
    echo 0x17901020 > $DCC_PATH/config    #APCS_CCI_GLADIATOR_MAIN_CRIXUS_ERRLOG1
    echo 0x17901024 > $DCC_PATH/config    #APCS_CCI_GLADIATOR_MAIN_CRIXUS_ERRLOG2
    echo 0x17901028 > $DCC_PATH/config    #APCS_CCI_GLADIATOR_MAIN_CRIXUS_ERRLOG3
    echo 0x1790102C > $DCC_PATH/config    #APCS_CCI_GLADIATOR_MAIN_CRIXUS_ERRLOG4
    echo 0x17901030 > $DCC_PATH/config    #APCS_CCI_GLADIATOR_MAIN_CRIXUS_ERRLOG5
    echo 0x17901034 > $DCC_PATH/config    #APCS_CCI_GLADIATOR_MAIN_CRIXUS_ERRLOG6
    echo 0x1790103C > $DCC_PATH/config    #APCS_CCI_GLADIATOR_MAIN_CRIXUS_ERRLOG8
    echo 0x17904008 > $DCC_PATH/config    #APCS_CCI_PD_GNOC_MAIN_PROGPOWERCONTROLLER_TARGET0
    echo 0x1790400C > $DCC_PATH/config    #APCS_CCI_PD_GNOC_MAIN_PROGPOWERCONTROLLER_TARGET1
    echo 0x17904010 > $DCC_PATH/config    #APCS_CCI_PD_GNOC_MAIN_PROGPOWERCONTROLLER_TARGET2
    echo 0x17904014 > $DCC_PATH/config    #APCS_CCI_PD_GNOC_MAIN_PROGPOWERCONTROLLER_TARGET3

    #CCI_SAW4_1_1_SPM
    echo 0x179D2000 > $DCC_PATH/config    #SPM_CTL
    #CCI_SAW4_1_1_STS
    echo 0x179D2C0C > $DCC_PATH/config    #SPM_STS
    echo 0x179D2C10 > $DCC_PATH/config    #SPM_STS2
    echo 0x179D2C20 > $DCC_PATH/config    #SPM_STS3
    echo 0x179D2C18 > $DCC_PATH/config    #PMIC_STS

    #BIMC_GLOBAL2
    echo 0x010021F0 > $DCC_PATH/config    #BIMC_BRIC_DEFAULT_SEGMENT
    echo 0x010021F4 > $DCC_PATH/config    #BIMC_BRIC_REDIRECT_CTRL
    echo 0x010021F8 > $DCC_PATH/config    #BIMC_BRIC_REDIRECT_MSTR_EN
    echo 0x010021FC > $DCC_PATH/config    #BIMC_BRIC_REDIRECT_CTRL_STATUS

    #GCC_GPLL0
    echo 0x100000 10 > $DCC_PATH/config

    #GCC_GPLL1
    echo 0x101000 10 > $DCC_PATH/config

    #GCC_GPLL2
    echo 0x102000 10 > $DCC_PATH/config

    #GCC_GPLL3
    echo 0x103000 10  > $DCC_PATH/config

    #GCC_GPLL4
    echo 0x177000 10 > $DCC_PATH/config

    #GCC_GPLL5
    echo 0x174000 10 > $DCC_PATH/config

    echo 0x151000 > $DCC_PATH/config    #GCC_RPM_GPLL_ENA_VOTE

    echo 0x144004 > $DCC_PATH/config    #GCC_BIMC_GDSCR
    echo 0x146048 > $DCC_PATH/config    #GCC_DDR_DIM_WRAPPER_GDSCR
    echo 0x183004 > $DCC_PATH/config    #GCC_AGGRE2_NOC_GDSCR

    echo 0x104020 2 > $DCC_PATH/config
    echo 0x104040 2 > $DCC_PATH/config
    echo 0x105038 2 > $DCC_PATH/config
    echo 0x10A008 2 > $DCC_PATH/config

    #GCC_CNOC
    echo 0x105050 2 > $DCC_PATH/config

    #GCC_QDSS
    echo 0x10D000 2 > $DCC_PATH/config
    echo 0x10D018 2 > $DCC_PATH/config
    echo 0x10D030 2 > $DCC_PATH/config

    echo 0x10E000 2 > $DCC_PATH/config
    echo 0x10E018 2 > $DCC_PATH/config
    echo 0x10E030 2 > $DCC_PATH/config
    echo 0x10E048 2 > $DCC_PATH/config

    #GCC_RPM
    echo 0x13C018 2 > $DCC_PATH/config

    #GCC_CE1
    echo 0x141010 2 > $DCC_PATH/config

    #GCC_BIMC
    echo 0x145018 2 > $DCC_PATH/config

    #GCC_BIMC_DDR_CPLL0_ROOT
    echo 0x146010 2 > $DCC_PATH/config

    #GCC_BIMC_DDR_CPLL1_ROOT
    echo 0x146028 2 > $DCC_PATH/config

    #GCC_CDSP_BIMC
    echo 0x147030 2 > $DCC_PATH/config

    echo 0x148014 2 > $DCC_PATH/config

    echo 0x14802C 2 > $DCC_PATH/config

    echo 0x18A024 2 > $DCC_PATH/config

    echo 0x17101C 2 > $DCC_PATH/config

    echo 0x189018 2 > $DCC_PATH/config

    echo 0x17A014 2 > $DCC_PATH/config

    echo 0x17A02C 2 > $DCC_PATH/config
    echo 0x17A044 2 > $DCC_PATH/config
    echo 0x17A05C 2 > $DCC_PATH/config
    echo 0x17A074 2 > $DCC_PATH/config

    echo 0x146004 2 > $DCC_PATH/config

    echo 0xC8CC000 10 > $DCC_PATH/config

    echo 0xC8CC050 10 > $DCC_PATH/config

    echo 0xC8C00F0 10 > $DCC_PATH/config

    echo 0xC8C4000 > $DCC_PATH/config	 #MMSS_PLL_VOTE_RPM

    echo 0xC8CD000 2 > $DCC_PATH/config

    echo  0x1030560 1 > $DCC_PATH/config 	##BIMC_S_DDR0_SCMO_RCH_STATUS
    echo  0x10305a0 1 > $DCC_PATH/config 	##BIMC_S_DDR0_SCMO_WCH_STATUS
    echo  0x103c560 1 > $DCC_PATH/config 	##BIMC_S_DDR1_SCMO_RCH_STATUS
    echo  0x103c5a0 1 > $DCC_PATH/config 	##BIMC_S_DDR1_SCMO_WCH_STATUS
    echo  0x1030520 1 > $DCC_PATH/config 	##BIMC_S_DDR0_SCMO_CMD_BUF_STATUS
    echo  0x103c520 1 > $DCC_PATH/config 	##BIMC_S_DDR1_SCMO_CMD_BUF_STATUS
    echo  0x103408c 1 > $DCC_PATH/config 	##BIMC_S_DDR0_DPE_DRAM_STATUS_0
    echo  0x104008c 1 > $DCC_PATH/config 	##BIMC_S_DDR1_DPE_DRAM_STATUS_0
    echo  0x103409c 1 > $DCC_PATH/config 	##BIMC_S_DDR0_DPE_MEMC_STATUS_0
    echo  0x104009c 1 > $DCC_PATH/config 	##BIMC_S_DDR1_DPE_MEMC_STATUS_0
    echo  0xffd220  1 > $DCC_PATH/config 	##MCCC_MCCC_CLK_PERIOD
    echo  0x108f094 1 > $DCC_PATH/config 	##DDR_CC_MCCC_DDRCC_MCCC_TOP_STATUS
    echo  0xffd200  1 > $DCC_PATH/config 	##MCCC_MCCC_FREQ_SWITCH_UPDATE
    echo  0xffd02c  1 > $DCC_PATH/config 	##MCCC_MCCC_CH0_FSC_STATUS0
    echo  0xffd038  1 > $DCC_PATH/config 	##MCCC_MCCC_CH0_FSC_STATUS3
    echo  0xffd12c  1 > $DCC_PATH/config 	##MCCC_MCCC_CH1_FSC_STATUS0
    echo  0xffd138  1 > $DCC_PATH/config 	##MCCC_MCCC_CH1_FSC_STATUS3
    echo  0x1086020 1 > $DCC_PATH/config 	##CH0_DDRCC_PLLCTRL_GCC_CTRL
    echo  0x1086028 1 > $DCC_PATH/config 	##CH0_DDRCC_PLLCTRL_CLK_SWITCH_STATUS
    echo  0x1086030 1 > $DCC_PATH/config 	##CH0_DDRCC_PLLCTRL_STATUS
    echo  0x1086124 1 > $DCC_PATH/config 	##CH0_DDRCC_PLL0_STATUS
    echo  0x1086164 1 > $DCC_PATH/config 	##CH0_DDRCC_PLL1_STATUS
    echo  0x10861dc 1 > $DCC_PATH/config 	##CH0_DDRCC_DLL0_STATUS
    echo  0x10861ec 1 > $DCC_PATH/config 	##CH0_DDRCC_DLL1_STATUS
    echo  0x1035070 1 > $DCC_PATH/config 	##BIMC_S_DDR0_SHKE_MREG_RDATA_STATUS
    echo  0x1041070 1 > $DCC_PATH/config 	##BIMC_S_DDR1_SHKE_MREG_RDATA_STATUS
    echo  0x10340b8 1 > $DCC_PATH/config 	##BIMC_S_DDR0_DPE_INTERRUPT_STATUS
    echo  0x103408c 1 > $DCC_PATH/config 	##BIMC_S_DDR0_DPE_DRAM_STATUS_0
    echo  0x1035074 1 > $DCC_PATH/config 	##BIMC_S_DDR0_SHKE_DRAM_STATUS

    ##BIMC_S_DDR0_SHKE_PERIODIC_MRR_RDATA
    echo 0x10350b0 4 > $DCC_PATH/config

    echo  0x10400b8 1 > $DCC_PATH/config 	##BIMC_S_DDR1_DPE_INTERRUPT_STATUS
    echo  0x104008c 1 > $DCC_PATH/config 	##BIMC_S_DDR1_DPE_DRAM_STATUS_0
    echo  0x1041074 1 > $DCC_PATH/config 	##BIMC_S_DDR1_SHKE_DRAM_STATUS

    ##BIMC_S_DDR1_SHKE_PERIODIC_MRR_RDATA
    echo  0x10410b0 4 > $DCC_PATH/config

    echo  0x1008100 1 > $DCC_PATH/config 	##BIMC_M_APP_MPORT_INTERRUPT_STATUS
    echo  0x1020100 1 > $DCC_PATH/config 	##BIMC_M_CDSP_MPORT_INTERRUPT_STATUS
    echo  0x100c100 1 > $DCC_PATH/config 	##BIMC_M_GPU_MPORT_INTERRUPT_STATUS
    echo  0x101c100 1 > $DCC_PATH/config 	##BIMC_M_MDSP_MPORT_INTERRUPT_STATUS
    echo  0x1010100 1 > $DCC_PATH/config 	##BIMC_M_MMSS_MPORT_INTERRUPT_STATUS
    echo  0x1018100 1 > $DCC_PATH/config 	##BIMC_M_PIMEM_MPORT_INTERRUPT_STATUS
    echo  0x1014100 1 > $DCC_PATH/config 	##BIMC_M_SYS_MPORT_INTERRUPT_STATUS

    ##BIMC_M_APP_MPORT_STATUS
    echo  0x1008420 2 > $DCC_PATH/config

    ##BIMC_M_CDSP_MPORT_STATUS
    echo  0x1020420 2 > $DCC_PATH/config

    ##BIMC_M_GPU_MPORT_STATUS
    echo  0x100c420 2 > $DCC_PATH/config

    ##BIMC_M_MDSP_MPORT_STATUS
    echo  0x101c420 2 > $DCC_PATH/config

    ##BIMC_M_MMSS_MPORT_STATUS
    echo  0x1010420 2 > $DCC_PATH/config

    ##BIMC_M_PIMEM_MPORT_STATUS
    echo  0x1018420 2 > $DCC_PATH/config

    ##BIMC_M_SYS_MPORT_STATUS
    echo  0x1014420 2 > $DCC_PATH/config

    #BIMC_M_APP_MPORT_STATUS
    echo  0x1008430 2 > $DCC_PATH/config

    ##BIMC_M_CDSP_MPORT_STATUS
    echo  0x1020430 2 > $DCC_PATH/config

    ##BIMC_M_GPU_MPORT_STATUS
    echo  0x100c430 2 > $DCC_PATH/config

    ##BIMC_M_MDSP_MPORT_STATUS
    echo  0x101c430 2 > $DCC_PATH/config

    ##BIMC_M_MMSS_MPORT_STATUS
    echo  0x1010430 2 > $DCC_PATH/config

    ##BIMC_M_PIMEM_MPORT_STATUS
    echo  0x1018430 2 > $DCC_PATH/config

    ##BIMC_M_SYS_MPORT_STATUS
    echo  0x1014430 2 > $DCC_PATH/config

    echo  0x1030100 1 > $DCC_PATH/config 	##BIMC_S_DDR0_SCMO_INTERRUPT_STATUS
    echo  0x1030124 1 > $DCC_PATH/config 	##BIMC_S_DDR0_SCMO_ESYN_ADDR1
    echo  0x103012c 1 > $DCC_PATH/config 	##BIMC_S_DDR0_SCMO_ESYN_APACKET_1
    echo  0x1030130 1 > $DCC_PATH/config 	##BIMC_S_DDR0_SCMO_ESYN_APACKET_2
    echo  0x103c100 1 > $DCC_PATH/config 	##BIMC_S_DDR1_SCMO_INTERRUPT_STATUS
    echo  0x103c124 1 > $DCC_PATH/config 	##BIMC_S_DDR1_SCMO_ESYN_ADDR1
    echo  0x103c12c 1 > $DCC_PATH/config 	##BIMC_S_DDR1_SCMO_ESYN_APACKET_1
    echo  0x103c130 1 > $DCC_PATH/config 	##BIMC_S_DDR1_SCMO_ESYN_APACKET_2

    echo  1 > $DCC_PATH/enable
}

# Function MSM8996 DCC configuration
enable_msm8996_dcc_config()
{
    DCC_PATH="/sys/bus/platform/devices/4b3000.dcc"
    if [ ! -d $DCC_PATH ]; then
        echo "DCC don't exist on this build."
        return
    fi

    echo  0 > $DCC_PATH/enable
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo  1 > $DCC_PATH/config_reset

    #SPM Registers
    # CPU0
    echo  0x998000C > $DCC_PATH/config
    echo  0x9980030 > $DCC_PATH/config
    echo  0x998003C > $DCC_PATH/config
    # CPU1
    echo  0x999000C > $DCC_PATH/config
    echo  0x9990030 > $DCC_PATH/config
    echo  0x999003C > $DCC_PATH/config
    # CPU2
    echo  0x99B000C > $DCC_PATH/config
    echo  0x99B0030 > $DCC_PATH/config
    echo  0x99B003C > $DCC_PATH/config
    # CPU3
    echo  0x99C000C > $DCC_PATH/config
    echo  0x99C0030 > $DCC_PATH/config
    echo  0x99C003C > $DCC_PATH/config
    # PWRL2
    echo  0x99A000C > $DCC_PATH/config
    echo  0x99A0030 > $DCC_PATH/config
    echo  0x99A003C > $DCC_PATH/config
    # PERFL2
    echo  0x99D000C > $DCC_PATH/config
    echo  0x99D0030 > $DCC_PATH/config
    echo  0x99D003C > $DCC_PATH/config
    # L3
    echo  0x9A0000C > $DCC_PATH/config
    echo  0x9A00030 > $DCC_PATH/config
    echo  0x9A0003C > $DCC_PATH/config
    # CBF
    echo  0x9A1000C > $DCC_PATH/config
    echo  0x9A10030 > $DCC_PATH/config
    echo  0x9A1003C > $DCC_PATH/config
    # PWR L2 HW-FLUSH
    echo  0x99A1060 > $DCC_PATH/config
    # PERF L2 HW-FLUSH
    echo  0x99D1060 > $DCC_PATH/config
    # APCS_APC0_SLEEP_EN_VOTE
    echo  0x99A2030 > $DCC_PATH/config
    # APCS_APCC_SW_EN_VOTE
    echo  0x99E0020 > $DCC_PATH/config
    # pIMEM
    echo  0x0038070 > $DCC_PATH/config
    echo  0x0038074 > $DCC_PATH/config
    echo  0x0038078 > $DCC_PATH/config
    echo  0x003807C > $DCC_PATH/config
    echo  0x0038080 > $DCC_PATH/config
    echo  0x0038084 > $DCC_PATH/config
    echo  0x0038088 > $DCC_PATH/config
    echo  0x003808C > $DCC_PATH/config

    echo  1 > $DCC_PATH/enable
}

# Function MSM8953 DCC configuration
enable_msm8953_dcc_config()
{
    DCC_PATH="/sys/bus/platform/devices/b3000.dcc"
    if [ ! -d $DCC_PATH ]; then
        echo "DCC don't exist on this build."
        return
    fi

    echo  0 > $DCC_PATH/enable
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink

    #GCC_GPLL0
    echo 0x1821000 0x9 > $DCC_PATH/config

    #GCC_GPLL2
    echo 0x184A000 0x1 > $DCC_PATH/config
    echo 0x184A010 0x5 > $DCC_PATH/config

    #GCC_GPLL4
    echo 0x1824000 0x1 > $DCC_PATH/config
    echo 0x1824010 0x5 > $DCC_PATH/config

    #GCC_GPLL5
    echo 0x1825000 0x2 > $DCC_PATH/config
    echo 0x1825010 0x1 > $DCC_PATH/config
    echo 0x1825018 0x2 > $DCC_PATH/config
    echo 0x1825024 0x1 > $DCC_PATH/config

    #GCC_BIMC
    echo 0x1823000 0x2 > $DCC_PATH/config
    echo 0x1823010 0x1 > $DCC_PATH/config
    echo 0x1823018 0x2 > $DCC_PATH/config
    echo 0x1823024 0x1 > $DCC_PATH/config

    #GCC_GPLL6
    echo 0x1837000 0x1 > $DCC_PATH/config
    echo 0x1837010 0x1 > $DCC_PATH/config
    echo 0x1837018 0x2 > $DCC_PATH/config
    echo 0x1837024 0x1 > $DCC_PATH/config

    #GCC_SYSTEM_NOC
    echo 0x1826004 0x2 > $DCC_PATH/config

    #GCC_PCNOC
    echo 0x1827000 0x2 > $DCC_PATH/config

    #GCC_SYSTEM_MMNOC
    echo 0x183D000 0x2 > $DCC_PATH/config

    #GCC_DDR
    echo 0x1832024 0x2 > $DCC_PATH/config

    #GCC_BIMC
    echo 0x1831018 0x1 > $DCC_PATH/config
    echo 0x1831004 0x1 > $DCC_PATH/config
    echo 0x1831024 0x3 > $DCC_PATH/config

    #GCC_Q6
    echo 0x1838030 0x2 > $DCC_PATH/config

    #GCC_APSS_TCU
    echo 0x1838000 0x2 > $DCC_PATH/config

    #GCC_APSS_AXI
    echo 0x1838048 0x2 > $DCC_PATH/config

    # OCIMEM START  #MARK the start
    echo 0x00448560 1 > $DCC_PATH/config
    echo 0x004485A0 1 > $DCC_PATH/config
    echo 0x00448520 1 > $DCC_PATH/config
    echo 0x00448450 1 > $DCC_PATH/config
    echo 0x0044C08C 1 > $DCC_PATH/config
    echo 0x0044C09C 1 > $DCC_PATH/config
    echo 0x00408420 1 > $DCC_PATH/config
    echo 0x00408424 1 > $DCC_PATH/config
    echo 0x00408430 1 > $DCC_PATH/config
    echo 0x00408434 1 > $DCC_PATH/config
    echo 0x0041c100 1 > $DCC_PATH/config
    echo 0x0041c420 1 > $DCC_PATH/config
    echo 0x0041c424 1 > $DCC_PATH/config
    echo 0x0041c430 1 > $DCC_PATH/config
    echo 0x0041c434 1 > $DCC_PATH/config

    echo 0x0040C420 1 > $DCC_PATH/config
    echo 0x0040C424 1 > $DCC_PATH/config
    echo 0x0040C430 1 > $DCC_PATH/config
    echo 0x0040C434 1 > $DCC_PATH/config

    echo 0x00414100 1 > $DCC_PATH/config
    echo 0x00414420 1 > $DCC_PATH/config
    echo 0x00414424 1 > $DCC_PATH/config
    echo 0x00414430 1 > $DCC_PATH/config
    echo 0x00414434 1 > $DCC_PATH/config
    echo 0x00418420 1 > $DCC_PATH/config
    echo 0x00418424 1 > $DCC_PATH/config
    echo 0x00418430 1 > $DCC_PATH/config
    echo 0x00418434 1 > $DCC_PATH/config

    echo 0x00410420 1 > $DCC_PATH/config
    echo 0x00410424 1 > $DCC_PATH/config
    echo 0x00410430 1 > $DCC_PATH/config
    echo 0x00410434 1 > $DCC_PATH/config

    echo 0x00420420 1 > $DCC_PATH/config
    echo 0x00420424 1 > $DCC_PATH/config
    echo 0x00420430 1 > $DCC_PATH/config
    echo 0x00420434 1 > $DCC_PATH/config

    echo  1 > $DCC_PATH/enable
}

# Function MSM8976 DCC configuration
enable_msm8976_dcc_config()
{
    DCC_PATH="/sys/bus/platform/devices/b3000.dcc"
    if [ ! -d $DCC_PATH ]; then
        echo "DCC don't exist on this build."
        return
    fi

    echo  0 > $DCC_PATH/enable
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo  1 > $DCC_PATH/config_reset

    #BIMC_S_DDR0
    echo 0x00448500 41 > $DCC_PATH/config
    echo 0x0044D070 2 > $DCC_PATH/config
    #BIMC_S_DDR1
    echo 0x00450500 41 > $DCC_PATH/config
    echo 0x00455070 2 > $DCC_PATH/config
    #BMIC_M_XXX_MPORT
    echo 0x00408400 30 > $DCC_PATH/config
    echo 0x0040C400 30 > $DCC_PATH/config
    echo 0x00410400 30 > $DCC_PATH/config
    echo 0x00414400 30 > $DCC_PATH/config
    echo 0x00418400 30 > $DCC_PATH/config
    #APCS_ALIAS_APSS_GLB
    echo 0x0B011014 2  > $DCC_PATH/config
    echo 0x0B011210 1  > $DCC_PATH/config
    echo 0x0B011218 1  > $DCC_PATH/config
    #APCLUS1_L2_SAW2
    echo 0x0B01200C 1  > $DCC_PATH/config
    echo 0x0B012030 1  > $DCC_PATH/config
    #APCS_ALIAS4_APSS_ACS
    echo 0x0B088004 2  > $DCC_PATH/config
    echo 0x0B088064 1  > $DCC_PATH/config
    echo 0x0B088090 1  > $DCC_PATH/config
    #APCS_ALIAS4_SAW2
    echo 0x0B08900C 1  > $DCC_PATH/config
    echo 0x0B089030 1  > $DCC_PATH/config
    #APCS_ALIAS5_APSS_ACS
    echo 0x0B098004 2  > $DCC_PATH/config
    echo 0x0B098064 1  > $DCC_PATH/config
    echo 0x0B098090 1  > $DCC_PATH/config
    #APCS_ALIAS5_SAW2
    echo 0x0B09900C 1  > $DCC_PATH/config
    echo 0x0B099030 1  > $DCC_PATH/config
    #APCS_ALIAS6_APSS_ACS
    echo 0x0B0A8004 2  > $DCC_PATH/config
    echo 0x0B0A8064 1  > $DCC_PATH/config
    echo 0x0B0A8090 1  > $DCC_PATH/config
    #APCS_ALIAS6_SAW2
    echo 0x0B0A900C 1  > $DCC_PATH/config
    echo 0x0B0A9030 1  > $DCC_PATH/config
    #APCS_ALIAS7_APSS_ACS
    echo 0x0B0B8004 2  > $DCC_PATH/config
    echo 0x0B0B8064 1  > $DCC_PATH/config
    echo 0x0B0B8090 1  > $DCC_PATH/config
    #APCS_ALIAS7_SAW2
    echo 0x0B0B900C 1  > $DCC_PATH/config
    echo 0x0B0B9030 1  > $DCC_PATH/config
    #APCS_ALIAS0_APSS_GLB
    echo 0x0B111014 2  > $DCC_PATH/config
    echo 0x0B111210 1  > $DCC_PATH/config
    echo 0x0B111218 1  > $DCC_PATH/config
    #APCLUS0_L2_SAW2
    echo 0x0B11200C 1  > $DCC_PATH/config
    echo 0x0B112030 1  > $DCC_PATH/config
    #APCS_ALIAS0_APSS_ACS
    echo 0x0B188004 2  > $DCC_PATH/config
    echo 0x0B188064 1  > $DCC_PATH/config
    #APCS_ALIAS0_SAW2
    echo 0x0B18900C 1  > $DCC_PATH/config
    echo 0x0B189030 1  > $DCC_PATH/config
    #APCS_ALIAS1_APSS_ACS
    echo 0x0B198004 2  > $DCC_PATH/config
    echo 0x0B198064 1  > $DCC_PATH/config
    #APCS_ALIAS1_SAW2
    echo 0x0B19900C 1  > $DCC_PATH/config
    echo 0x0B199030 1  > $DCC_PATH/config
    #APCS_ALIAS2_APSS_ACS
    echo 0x0B1A8004 2  > $DCC_PATH/config
    echo 0x0B1A8064 1  > $DCC_PATH/config
    #APCS_ALIAS2_SAW2
    echo 0x0B1A900C 1  > $DCC_PATH/config
    echo 0x0B1A9030 1  > $DCC_PATH/config
    #APCS_ALIAS3_APSS_ACS
    echo 0x0B1B8004 2  > $DCC_PATH/config
    echo 0x0B1B8064 1  > $DCC_PATH/config
    #APCS_ALIAS3_SAW2
    echo 0x0B1B900C 1  > $DCC_PATH/config
    echo 0x0B1B9030 1  > $DCC_PATH/config
    #APCS_COMMON_APSS_SHARED
    echo 0x0B1D1058 2  > $DCC_PATH/config
    echo 0x0B1D200C 1  > $DCC_PATH/config
    echo 0x0B1D2030 1  > $DCC_PATH/config

    echo  1 > $DCC_PATH/enable
}

# Function DCC configuration
enable_dcc_config()
{
    target=`getprop ro.board.platform`

    if [ -f /sys/devices/soc0/soc_id ]; then
        soc_id=`cat /sys/devices/soc0/soc_id`
    else
        soc_id=`cat /sys/devices/system/soc/soc0/id`
    fi

    case "$target" in
        "msm8996")
            echo "Enabling DCC config for 8996."
            enable_msm8996_dcc_config
            ;;

	"msm8998")
	    echo "Enabling DCC config for msm8998."
	    enable_msm8998_dcc_config
	    ;;

        "sdm660")
            echo "Enabling DCC config for sdm660."
            enable_sdm660_dcc_config
            ;;

        "msm8953")
            echo "Enabling DCC config for 8953."
            enable_msm8953_dcc_config
            ;;

        "msm8952")
            case "$soc_id" in
                "266" | "274" | "277" | "278")
                     echo "Enabling DCC config for 8976."
                     enable_msm8976_dcc_config
                     ;;
            esac
            ;;
    esac
}

enable_msm8998_core_hang_config()
{
    CORE_PATH_SILVER="/sys/devices/system/cpu/hang_detect_silver"
    CORE_PATH_GOLD="/sys/devices/system/cpu/hang_detect_gold"
    if [ ! -d $CORE_PATH ]; then
        echo "CORE hang does not exist on this build."
        return
    fi

    #select instruction retire as the pmu event
    echo 0x7 > $CORE_PATH_SILVER/pmu_event_sel
    echo 0xA > $CORE_PATH_GOLD/pmu_event_sel

    #set the threshold to around 9 milli-second
    echo 0x2a300 > $CORE_PATH_SILVER/threshold
    echo 0x2a300 > $CORE_PATH_GOLD/threshold

    #To the enable core hang detection
    #echo 0x1 > /sys/devices/system/cpu/hang_detect_silver/enable
    #echo 0x1 > /sys/devices/system/cpu/hang_detect_gold/enable
}

enable_msm8998_osm_wdog_status_config()
{
    echo 1 > /sys/kernel/debug/osm/pwrcl_clk/wdog_trace_enable
    echo 1 > /sys/kernel/debug/osm/perfcl_clk/wdog_trace_enable
}

enable_msm8998_gladiator_hang_config()
{
    GLADIATOR_PATH="/sys/devices/system/cpu/gladiator_hang_detect"
    if [ ! -d $GLADIATOR_PATH ]; then
        echo "Gladiator hang does not exist on this build."
        return
    fi

    #set the threshold to around 9 milli-second
    echo 0x0002a300 > $GLADIATOR_PATH/ace_threshold
    echo 0x0002a300 > $GLADIATOR_PATH/io_threshold
    echo 0x0002a300 > $GLADIATOR_PATH/m1_threshold
    echo 0x0002a300 > $GLADIATOR_PATH/m2_threshold
    echo 0x0002a300 > $GLADIATOR_PATH/pcio_threshold

    #To enable gladiator hang detection
    #echo 0x1 > /sys/devices/system/cpu/gladiator_hang_detect/enable
}

enable_osm_wdog_status_config()
{
    target=`getprop ro.board.platform`

    case "$target" in
        "msm8998")
            echo "Enabling OSM WDOG status registers for msm8998"
            enable_msm8998_osm_wdog_status_config
        ;;
    esac
}

enable_core_gladiator_hang_config()
{
    target=`getprop ro.board.platform`

    case "$target" in
        "msm8998")
            echo "Enabling core & gladiator config for msm8998"
            enable_msm8998_core_hang_config
            enable_msm8998_gladiator_hang_config
        ;;
    esac
}

coresight_config=`getprop persist.debug.coresight.config`
coresight_stm_cfg_done=`getprop ro.dbg.coresight.stm_cfg_done`

#Android turns off tracing by default. Make sure tracing is turned on after boot is done
if [ ! -z $coresight_stm_cfg_done ]
then
    echo 1 > /sys/kernel/debug/tracing/tracing_on
    exit
fi

enable_dcc_config
enable_core_gladiator_hang_config
enable_osm_wdog_status_config

case "$coresight_config" in
    "stm-events")
        if [ $target == "sdm660" ]; then
        echo "Enabling STM/Debug events for SDM660"
        enable_sdm660_debug
        else
        echo "Enabling STM events."
        enable_stm_events
        setprop ro.dbg.coresight.stm_cfg_done 1
        fi
        ;;
    *)
        echo "Skipping coresight configuration."
        exit
        ;;
esac
