#!/bin/bash

echo "Starting Docker containers..."
docker compose -f compose-development.yml --env-file .env.development up -d

if [ $? -eq 0 ]; then
    echo "Containers started successfully!"
    echo ""
    echo "Your Laravel development environment is now running at:"
    echo " Web: http://localhost"
    echo " MailHog: http://localhost:8025"
    echo " PostgreSQL: localhost:5432"
    echo " Redis: localhost:6379"
    echo ""
    echo "You can now use inside the src folder:"
    echo "  ../dev-run laravel new ."
    echo "  ../dev-run composer update"
    echo "  ../dev-run npm install"
else
    echo "Failed to start containers!"
fi