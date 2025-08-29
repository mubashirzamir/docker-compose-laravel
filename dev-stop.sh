#!/bin/bash

echo "Stopping Docker containers..."
docker compose -f compose-development.yml --env-file .env.development stop

if [ $? -eq 0 ]; then
    echo "Containers stopped successfully!"
    echo ""
    echo "Your Laravel development environment has been stopped."
    echo "To start it again, run: ./dev-up.sh"
    echo "To completely remove containers, run: ./dev-down.sh"
else
    echo "Failed to stop containers!"
fi
