#!/bin/sh
# 2022, Wig Cheng <wigcheng@ieiworld.com>
BOARD_DIR="$(dirname $0)"


# copy test scripts to rootfs
cp ${BOARD_DIR}/test-additions/panel-screen-test.sh ${TARGET_DIR}/usr/bin/panel-screen-test.sh
cp ${BOARD_DIR}/test-additions/test_buzzer.sh ${TARGET_DIR}/usr/bin/test_buzzer.sh
cp ${BOARD_DIR}/test-additions/test_lightbar.sh ${TARGET_DIR}/usr/bin/test_lightbar.sh
cp ${BOARD_DIR}/test-additions/check_emmc.sh ${TARGET_DIR}/usr/bin/check_emmc.sh
