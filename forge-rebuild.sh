#!/bin/bash

echo "Rebuilding Docker images..."
docker compose -f compose-development.yml --env-file .env.development build --no-cache

if [ $? -eq 0 ]; then
    echo "Rebuild successful!"
    echo ""
    echo "To start containers, run: ./forge-up.sh"
else
    echo "Rebuild failed!"
fi
