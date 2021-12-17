#!/bin/bash
# Ask the user for login details

echo "Streamboks Setup. Please fill in variables when prompted."

# Setup env variables
read -p 'WS_ID: ' WS_ID
read -p 'WS_URL: ' WS_URL

sed -i '/# WS_ID/d' ~/.profle
sed -i '/# WS_URL/d' ~/.profle

cat << EOT >> ~/.profile
export WS_ID="$WS_ID"
export WS_URL="$WS_URL"
EOT

# Load the updated variables
source ~/.profile

# PM2
npm install -g pm2
pm2 startup
sudo env PATH=$PATH:/usr/bin /usr/local/lib/node_modules/pm2/bin/pm2 startup systemd -u ${FIRST_USER_NAME} --hp /home/${FIRST_USER_NAME}

# Start
pm2 start
pm2 save

echo "Setup completed! Check logs with 'pm2 logs' to verify the success."