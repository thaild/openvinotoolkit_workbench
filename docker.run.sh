export LOCAL_ADDR=$(ipconfig getifaddr en0)
docker compose -f docker/docker-compose.local.yml up -d
