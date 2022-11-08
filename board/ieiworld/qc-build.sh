#!/bin/sh
# 2022, Wig Cheng <wigcheng@ieiworld.com>
BOARD_DIR="$(dirname $0)"


# copy test scripts to rootfs
mkdir ${TARGET_DIR}/qc
cp ${BOARD_DIR}/qc-additions/buzzer_qc.sh ${TARGET_DIR}/qc/buzzer_qc.sh
cp ${BOARD_DIR}/qc-additions/lcd_qc.sh ${TARGET_DIR}/qc/lcd_qc.sh
cp ${BOARD_DIR}/qc-additions/touch_qc.sh ${TARGET_DIR}/qc/touch_qc.sh

# copy AP6275S_firmware
cp ${BOARD_DIR}/AP6275S_firmware/fw_bcm43752a2_ag* ${TARGET_DIR}/lib/firmware/
cp ${BOARD_DIR}/AP6275S_firmware/clm_bcm43752a2_ag.blob ${TARGET_DIR}/lib/firmware/
cp ${BOARD_DIR}/AP6275S_firmware/nvram_ap6275s.txt ${TARGET_DIR}/lib/firmware/
