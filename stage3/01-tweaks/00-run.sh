#!/bin/bash -e

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_boot_wait 1
EOF

# Add the pm2 ecosystem for sb-streamboks
install -m 644 files/ecosystem.config.js "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"

# Add sb-nodejs-bootloader
mkdir -p ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/sb-nodejs-bootloader
unzip -o files/sb-nodejs-bootloader.zip -d ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/sb-nodejs-bootloader

# Add the bootloader app config for sb-streamboks
install -m 644 files/.sb-streamboks.json "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/sb-nodejs-bootloader/apps/"

# Add env variables for the apps (If not already added)
grep -qxF 'UPDATER_USERNAME' ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.profile || cat << EOT >> ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.profile

# Custom env variables
export UPDATER_USERNAME="streampass"
export UPDATER_PASSWORD="1By4YWdijvh2SNkeMXUoo8oko"
export UPDATER_URL="https://streamboks.jfrog.io"
EOT

# Add the setup script to user home
install -m 644 files/setup.sh "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/setup.sh"
sed -e "s/\${FIRST_USER_NAME}/${FIRST_USER_NAME}/" "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/setup.sh"

