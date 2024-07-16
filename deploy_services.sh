#! /bin/bash
# This file assumes it is placed in a directory that is within a parent directory that also houses many services
# For example
# /some/path/admin/deploy_services.sh
# /some/path/service1/service1.service
# /some/path/service2/service2.service
# It also assumes at the root of these other services is a file called *.service formatted for systemd in Ubuntu
# It will persist these to a configured ubuntu box, make sure they are configured to start at start up, and enable them

# Get all directories within my parent directory
for directory in $(ls -d ../*); do
    if [ -f $directory/*.service ]; then
        # get name of service file
        service_file_full_path=$(ls $directory/*.service)
        service_file_name=$(basename $service_file_full_path)
        # Step 2: SCP the Go binary to the EC2 instance
        echo "Copying Service File EC2 instance..."
        scp -i $EC2_PEM_PATH $service_file_full_path ubuntu@$EC2_PUBLIC_IP:/home/ubuntu/.temp/ || { echo "SCP failed"; exit 1; }
        echo "Service file name: $service_file_name Uploaded..."
        ssh -i $EC2_PEM_PATH ubuntu@$EC2_PUBLIC_IP << EOF
            sudo mv ./.temp/$service_file_name /etc/systemd/system/ || { echo "Failed to move the file"; exit 1; }
            echo "File moved successfully"
            sudo systemctl daemon-reload || { echo "Failed to reload daemon"; exit 1; }
            sudo systemctl enable $service_file_name || { echo "Failed to enable the service"; exit 1; }
            echo "Service enabled successfully"
            sudo systemctl restart $service_file_name || { echo "Failed to restart the service"; exit 1; }
            echo "Service restarted successfully"
            sudo systemctl status $service_file_name || { echo "Failed to check the status of the service"; exit 1; }
            echo "Service status checked successfully"
EOF
        echo "Service $service_file_name deployed successfully"
    fi
done