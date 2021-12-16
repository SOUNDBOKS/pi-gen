#!/bin/bash -e

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_boot_wait 1
EOF

# Install NVM and NodeJS
on_chroot << EOF
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  nvm install 16
  nvm alias default 16
EOF

# Install NodeJS 16 and make it default (via nvm)
on_chroot << EOF

EOF

#  Install and configure PM2
on_chroot << EOF
  npm install pm2 -g
  pm2 startup
  env PATH=$PATH:/usr/bin /usr/local/lib/node_modules/pm2/bin/pm2 startup systemd -u soundboks --hp ${ROOTFS_DIR}/home/${FIRST_USER_NAME}
EOF

# Add the pm2 ecosystem for sb-streamboks
install -m 644 files/ecosystem.config.json "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"

# Add sb-nodejs-bootloader
mkdir -p ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/sb-nodejs-bootloader
unzip -o files/sb-nodejs-bootloader.zip -d ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/sb-nodejs-bootloader

# Add the bootloader app config for sb-streamboks
install -m 644 files/ecosystem.config.json "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/sb-nodejs-bootloader/apps/.sb-streamboks.json"

# Add placeholder env variables for the apps (If not already added)
grep -qxF 'export WS_ID="<STREAMBOKS_CHANGE>"' ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.profile || cat << EOT >> ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.profile

# Custom env variables
export WS_ID="<STREAMBOKS_CHANGE>"
export WS_URL="<STREAMBOKS_CHANGE>"
export UPDATER_USERNAME="<STREAMBOKS_CHANGE>"
export UPDATER_PASSWORD="<STREAMBOKS_CHANGE>"
export UPDATER_URL="<STREAMBOKS_CHANGE>"
EOT

