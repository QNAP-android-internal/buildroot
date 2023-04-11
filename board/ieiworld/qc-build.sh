#!/bin/sh
# 2022, Wig Cheng <wigcheng@ieiworld.com>
BOARD_DIR="$(dirname $0)"


# copy test scripts to rootfs
mkdir -p ${TARGET_DIR}/qc
cp ${BOARD_DIR}/qc-additions/audio_qc.sh ${TARGET_DIR}/qc/audio_qc.sh
cp ${BOARD_DIR}/qc-additions/bt_qc.sh ${TARGET_DIR}/qc/bt_qc.sh
cp ${BOARD_DIR}/qc-additions/burn_mac.sh ${TARGET_DIR}/qc/burn_mac.sh
cp ${BOARD_DIR}/qc-additions/buzzer_qc.sh ${TARGET_DIR}/qc/buzzer_qc.sh
cp ${BOARD_DIR}/qc-additions/camera_qc.sh ${TARGET_DIR}/qc/camera_qc.sh
cp ${BOARD_DIR}/qc-additions/edp_qc.sh ${TARGET_DIR}/qc/edp_qc.sh
cp ${BOARD_DIR}/qc-additions/emmc_qc.sh ${TARGET_DIR}/qc/emmc_qc.sh
cp ${BOARD_DIR}/qc-additions/eth_qc.sh ${TARGET_DIR}/qc/eth_qc.sh
cp ${BOARD_DIR}/qc-additions/flash_image.sh ${TARGET_DIR}/qc/flash_image.sh
cp ${BOARD_DIR}/qc-additions/gpio_qc.sh ${TARGET_DIR}/qc/gpio_qc.sh
cp ${BOARD_DIR}/qc-additions/hdmi_qc.sh ${TARGET_DIR}/qc/hdmi_qc.sh
cp ${BOARD_DIR}/qc-additions/lightbar_qc.sh ${TARGET_DIR}/qc/lightbar_qc.sh
cp ${BOARD_DIR}/qc-additions/main.sh ${TARGET_DIR}/qc/main.sh
cp ${BOARD_DIR}/qc-additions/mem_qc.sh ${TARGET_DIR}/qc/mem_qc.sh
cp ${BOARD_DIR}/qc-additions/modem_qc.sh ${TARGET_DIR}/qc/modem_qc.sh
cp ${BOARD_DIR}/qc-additions/nor_qc.sh ${TARGET_DIR}/qc/nor_qc.sh
cp ${BOARD_DIR}/qc-additions/otg_qc.sh ${TARGET_DIR}/qc/otg_qc.sh
cp ${BOARD_DIR}/qc-additions/post-image.sh ${TARGET_DIR}/qc/post-image.sh
cp ${BOARD_DIR}/qc-additions/rtc_qc.sh ${TARGET_DIR}/qc/rtc_qc.sh
cp ${BOARD_DIR}/qc-additions/sd_qc.sh ${TARGET_DIR}/qc/sd_qc.sh
cp ${BOARD_DIR}/qc-additions/touch_qc.sh ${TARGET_DIR}/qc/touch_qc.sh
cp ${BOARD_DIR}/qc-additions/uart_qc.sh ${TARGET_DIR}/qc/uart_qc.sh
cp ${BOARD_DIR}/qc-additions/usb_qc.sh ${TARGET_DIR}/qc/usb_qc.sh
cp ${BOARD_DIR}/qc-additions/wifi_qc.sh ${TARGET_DIR}/qc/wifi_qc.sh

# copy qc config to rootfs
cp -r ${BOARD_DIR}/qc-additions/configs ${TARGET_DIR}/qc/
# decide to put config in boot partition ,board/ieiworld/qc-additions/post-image.sh

# copy AP6275S_firmware
cp ${BOARD_DIR}/AP6275S_firmware/fw_bcm43752a2_ag* ${TARGET_DIR}/lib/firmware/
cp ${BOARD_DIR}/AP6275S_firmware/clm_bcm43752a2_ag.blob ${TARGET_DIR}/lib/firmware/
cp ${BOARD_DIR}/AP6275S_firmware/nvram_ap6275s.txt ${TARGET_DIR}/lib/firmware/
cp ${BOARD_DIR}/AP6275S_firmware/BCM4362A2_001.003.006.1045.1053.hcd ${TARGET_DIR}/lib/firmware/

#service
cp ${BOARD_DIR}/qc-additions/service/qc_test.service ${TARGET_DIR}/etc/systemd/system/qc_test.service
