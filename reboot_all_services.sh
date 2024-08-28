#! /bin/bash
# This script restarts existing services on a configured Ubuntu box

# Get all directories within the parent directory
echo "Restarting all services"
for directory in $(ls -d ../*); do
    if [ -f $directory/*.service ]; then
        # Get name of service file
        service_file_full_path=$(ls $directory/*.service)
        service_file_name=$(basename $service_file_full_path)
        
        echo "Restarting service: $service_file_name"
        ssh -i $EC2_PEM_PATH ubuntu@$EC2_PUBLIC_IP << EOF
            sudo systemctl restart $service_file_name || { echo "Failed to restart the service"; exit 1; }
            echo "Service restarted successfully"
            sudo systemctl status $service_file_name || { echo "Failed to check the status of the service"; exit 1; }
            echo "Service status checked successfully"
EOF
        echo "Service $service_file_name restarted successfully"
    fi
done