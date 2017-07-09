#!/bin/bash
#
# Copyright (c) 2012, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

set -o errexit

usage() {
cat <<USAGE

Usage:
    bash $0 <TARGET_PRODUCT> [OPTIONS]

Description:
    Builds Android tree for given TARGET_PRODUCT

OPTIONS:
    -c, --clean_build
        Clean build - build from scratch by removing entire out dir

    -d, --debug
        Enable debugging - captures all commands while doing the build

    -h, --help
        Display this help message

    -i, --image
        Specify image to be build/re-build (bootimg/sysimg/usrimg)

    -j, --jobs
        Specifies the number of jobs to run simultaneously (Default: 8)

    -k, --kernel_defconf
        Specify defconf file to be used for compiling Kernel

    -l, --log_file
        Log file to store build logs (Default: <TARGET_PRODUCT>.log)

    -m, --module
        Module to be build

    -p, --project
        Project to be build

    -s, --setup_ccache
        Set CCACHE for faster incremental builds (true/false - Default: true)

    -u, --update-api
        Update APIs

    -v, --build_variant
        Build variant (Default: userdebug)

USAGE
}

clean_build() {
    echo -e "\nINFO: Removing entire out dir. . .\n"
    make clobber
}

build_android() {
    echo -e "\nINFO: Build Android tree for $TARGET\n"
    make $@ | tee $LOG_FILE.log
}

build_bootimg() {
    echo -e "\nINFO: Build bootimage for $TARGET\n"
    make bootimage $@ | tee $LOG_FILE.log
}

build_sysimg() {
    echo -e "\nINFO: Build systemimage for $TARGET\n"
    make systemimage $@ | tee $LOG_FILE.log
}

build_usrimg() {
    echo -e "\nINFO: Build userdataimage for $TARGET\n"
    make userdataimage $@ | tee $LOG_FILE.log
}

build_module() {
    echo -e "\nINFO: Build $MODULE for $TARGET\n"
    make $MODULE $@ | tee $LOG_FILE.log
}

build_project() {
    echo -e "\nINFO: Build $PROJECT for $TARGET\n"
    mmm $PROJECT | tee $LOG_FILE.log
}

update_api() {
    echo -e "\nINFO: Updating APIs\n"
    make update-api | tee $LOG_FILE.log
}

setup_ccache() {
    export CCACHE_DIR=../.ccache
    export USE_CCACHE=1
}

delete_ccache() {
    prebuilts/misc/linux-x86/ccache/ccache -C
    rm -rf $CCACHE_DIR
}

create_ccache() {
    echo -e "\nINFO: Setting CCACHE with 10 GB\n"
    setup_ccache
    delete_ccache
    prebuilts/misc/linux-x86/ccache/ccache -M 10G
}

# Set defaults
VARIANT="userdebug"
JOBS=8
CCACHE="true"

# Setup getopt.
long_opts="clean_build,debug,help,image:,jobs:,kernel_defconf:,log_file:,module:,"
long_opts+="project:,setup_ccache:,update-api,build_variant:"
getopt_cmd=$(getopt -o cdhi:j:k:l:m:p:s:uv: --long "$long_opts" \
            -n $(basename $0) -- "$@") || \
            { echo -e "\nERROR: Getopt failed. Extra args\n"; usage; exit 1;}

eval set -- "$getopt_cmd"

while true; do
    case "$1" in
        -c|--clean_build) CLEAN_BUILD="true";;
        -d|--debug) DEBUG="true";;
        -h|--help) usage; exit 0;;
        -i|--image) IMAGE="$2"; shift;;
        -j|--jobs) JOBS="$2"; shift;;
        -k|--kernel_defconf) DEFCONFIG="$2"; shift;;
        -l|--log_file) LOG_FILE="$2"; shift;;
        -m|--module) MODULE="$2"; shift;;
        -p|--project) PROJECT="$2"; shift;;
        -u|--update-api) UPDATE_API="true";;
        -s|--setup_ccache) CCACHE="$2"; shift;;
        -v|--build_variant) VARIANT="$2"; shift;;
        --) shift; break;;
    esac
    shift
done

# Mandatory argument
if [ $# -eq 0 ]; then
    echo -e "\nERROR: Missing mandatory argument: TARGET_PRODUCT\n"
    usage
    exit 1
fi
if [ $# -gt 1 ]; then
    echo -e "\nERROR: Extra inputs. Need TARGET_PRODUCT only\n"
    usage
    exit 1
fi
TARGET="$1"; shift

if [ -z $LOG_FILE ]; then
    LOG_FILE=$TARGET
fi

CMD="-j $JOBS"
if [ "$DEBUG" = "true" ]; then
    CMD+=" showcommands"
fi
if [ -n "$DEFCONFIG" ]; then
    CMD+=" KERNEL_DEFCONFIG=$DEFCONFIG"
fi

if [ "$CCACHE" = "true" ]; then
    setup_ccache
fi

source build/envsetup.sh
lunch $TARGET-$VARIANT

if [ "$CLEAN_BUILD" = "true" ]; then
    clean_build
    if [ "$CCACHE" = "true" ]; then
        create_ccache
    fi
fi

if [ "$UPDATE_API" = "true" ]; then
    update_api
fi

if [ -n "$MODULE" ]; then
    build_module "$CMD"
fi

if [ -n "$PROJECT" ]; then
    build_project
fi

if [ -n "$IMAGE" ]; then
    build_$IMAGE "$CMD"
fi

build_android "$CMD"
