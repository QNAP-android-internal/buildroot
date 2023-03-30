#!/usr/bin/env bash

# Please make sure that genext2fs gets installed

SOC="rk3568"
TOP_DIR=$(pwd)
BOARD_DIR="$(dirname $0)"
source ${BR2_CONFIG}
UBOOT_DIR="${BUILD_DIR}/uboot-${BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION}"

# pull rkbin
cd ${BUILD_DIR}
git clone git@github.com:QNAP-android-internal/rkbin.git
# pull prebuilts for the need of following images
mkdir -p prebuilts/gcc/linux-x86/aarch64
cd prebuilts/gcc/linux-x86/aarch64
git clone git@github.com:QNAP-android-internal/gcc-buildroot-9.3.0-2020.03-x86_64_aarch64-rockchip-linux-gnu.git
git clone git@github.com:QNAP-android-internal/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu.git

# make u-boot.itb
cd ${UBOOT_DIR}
./make.sh itb
# make idtloader.img
tools/mkimage -n ${SOC} -T rksd -d tpl/u-boot-tpl.bin idbloader.img
cat spl/u-boot-spl.bin >> idbloader.img

# make boot.img
cd ${BINARIES_DIR}
genext2fs -b 32768 -B $((32*1024*1024/32768)) -d bootfs/ -i 8192 -U boot.img

cd ${TOP_DIR}
mkdir -p ${BINARIES_DIR}/bootfs/extlinux
install -m 0644 -D ${BOARD_DIR}/extlinux.conf ${BINARIES_DIR}/bootfs/extlinux/extlinux.conf
install -m 0755 -D ${BINARIES_DIR}/Image ${BINARIES_DIR}/bootfs/
install -m 0644 -D ${BINARIES_DIR}/*.dtb ${BINARIES_DIR}/bootfs/
install -m 0755 -D ${UBOOT_DIR}/u-boot.itb ${BINARIES_DIR}/
install -m 0755 -D ${UBOOT_DIR}/idbloader.img ${BINARIES_DIR}/
