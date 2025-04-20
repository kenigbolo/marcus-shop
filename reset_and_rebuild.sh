#!/bin/bash

set -e

echo "🧼 Stopping and removing Docker containers..."
docker compose down -v

echo "🗑️ Removing volumes and cached networks..."
docker volume prune -f
docker network prune -f
docker system prune -af --volumes

echo "🐳 Rebuilding and starting containers..."
docker compose build
docker compose up -d db

# ✅ Wait for the PostgreSQL service to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."

DB_CONTAINER=$(docker compose ps -q db)

until docker exec "$DB_CONTAINER" pg_isready -U postgres -h localhost > /dev/null 2>&1; do
  echo "  ...waiting for db to accept connections"
  sleep 1
done

echo "✅ PostgreSQL is ready!"

echo "🚧 Preparing Rails app: cleaning and resetting DB..."
docker compose run --rm api bin/rails db:drop db:create db:migrate db:seed

echo "✅ Rails API reset complete."

echo "✅ Bringing up entire application stack..."
docker compose up -d

echo "🎉 All services are up and running!"

# echo "🧪 Running test suite..."
# docker compose run --rm api bin/rspec
