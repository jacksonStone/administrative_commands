#! /bin/bash
# Expects a variable that outlines the path to the .env file, 
# and that the .env file name is the same as what is specified in the service files
scp -i $EC2_PEM_PATH $UBUNTU_ENV ubuntu@$EC2_PUBLIC_IP:/home/ubuntu/ || { echo "SCP failed"; exit 1; }
# We now redeploy all services so they can pick up the new envs
./deploy_services.sh