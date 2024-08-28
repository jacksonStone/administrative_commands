#!/bin/bash
# This script restarts existing services on a configured Ubuntu box

# Store the original directory
original_dir=$(pwd)

echo "Re-deploying and restarting all services"
for directory in ../*/; do
    if [ -f "${directory}deploy.sh" ]; then
        echo "Re-deploying and restarting service: ${directory}"
        (
            cd "${directory}" && ./deploy.sh
        )
    fi
done

# Return to the original directory
cd "$original_dir"