#!/bin/sh
# 2022, Wig Cheng <wigcheng@ieiworld.com>
BOARD_DIR="$(dirname $0)"


# copy test scripts to rootfs
mkdir -p ${TARGET_DIR}/qc
cp ${BOARD_DIR}/installer-additions/flash_qc.sh ${TARGET_DIR}/qc/flash_qc.sh
cp ${BOARD_DIR}/installer-additions/main.sh ${TARGET_DIR}/qc/main.sh

# copy qc config to rootfs
#cp -r ${BOARD_DIR}/qc-additions/configs ${TARGET_DIR}/qc/
# decide to put config in boot partition ,board/ieiworld/qc-additions/post-image.sh

# copy AP6275S_firmware
cp ${BOARD_DIR}/AP6275S_firmware/fw_bcm43752a2_ag* ${TARGET_DIR}/lib/firmware/
cp ${BOARD_DIR}/AP6275S_firmware/clm_bcm43752a2_ag.blob ${TARGET_DIR}/lib/firmware/
cp ${BOARD_DIR}/AP6275S_firmware/nvram_ap6275s.txt ${TARGET_DIR}/lib/firmware/
cp ${BOARD_DIR}/AP6275S_firmware/BCM4362A2_001.003.006.1045.1053.hcd ${TARGET_DIR}/lib/firmware/

#service
cp ${BOARD_DIR}/qc-additions/service/qc_test.service ${TARGET_DIR}/etc/systemd/system/qc_test.service
