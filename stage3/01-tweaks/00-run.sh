#!/bin/bash -e

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_boot_wait 1
EOF

#  Install PM2
on_chroot <<EOF
  npm install pm2 -g
EOF

# Add sb-nodejs-bootloader
mkdir ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/sb-nodjs-bootloader
unzip ${BASE_DIR}/sb-base-code/sb-nodejs-bootloader.zip -d ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/sb-nodjs-bootloader

# Add the bootloader app config for sb-streamboks
cat <<EOT > ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/sb-nodjs-bootloader/apps/.sb-streamboks.json
"path": "sb-streamboks",
"repo": "streamboks",
"file": "dist.zip",
"main": "src/index.js",
"busy": false
EOT

# Add placeholder env variables for the apps
cat <<EOT >> ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.profile
export UPDATER_USERNAME="<STREAMBOKS_CHANGE>"
export UPDATER_PASSWORD="<STREAMBOKS_CHANGE>"
export UPDATER_URL="<STREAMBOKS_CHANGE>"
EOT