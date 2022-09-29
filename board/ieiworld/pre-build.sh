#!/bin/sh
# 2022, Wig Cheng <wigcheng@ieiworld.com>
BOARD_DIR="$(dirname $0)"


# copy test scripts to rootfs
cp ${BOARD_DIR}/test-additions/panel-screen-test.sh ${TARGET_DIR}/usr/bin/panel-screen-test.sh
cp ${BOARD_DIR}/test-additions/test_buzzer.sh ${TARGET_DIR}/usr/bin/test_buzzer.sh
cp ${BOARD_DIR}/test-additions/test_lightbar.sh ${TARGET_DIR}/usr/bin/test_lightbar.sh
cp ${BOARD_DIR}/test-additions/check_emmc.sh ${TARGET_DIR}/usr/bin/check_emmc.sh


# copy AP6275S_firmware
cp ${BOARD_DIR}/AP6275S_firmware/fw_bcm43752a2_ag* ${TARGET_DIR}/lib/firmware/
cp ${BOARD_DIR}/AP6275S_firmware/clm_bcm43752a2_ag.blob ${TARGET_DIR}/lib/firmware/
cp ${BOARD_DIR}/AP6275S_firmware/nvram_ap6275s.txt ${TARGET_DIR}/lib/firmware/
