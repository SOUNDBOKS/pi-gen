#!/bin/bash
# Ask the user for login details

echo "Streamboks Setup. Please fill in variables when prompted."

# Setup env variables
read -p 'WS_ID: ' WS_ID
read -p 'WS_URL: ' WS_URL

sed -i '/WS_ID/d' /home/${FIRST_USER_NAME}/.profile
sed -i '/WS_URL/d' /home/${FIRST_USER_NAME}/.profile

cat << EOT >> /home/${FIRST_USER_NAME}/.profile
export WS_ID="$WS_ID"
export WS_URL="$WS_URL"
EOT

# Load the updated variables
source /home/${FIRST_USER_NAME}/.profile

# Start
pm2 start
pm2 save

echo "Setup completed! Check logs with 'pm2 logs' to verify the success."