# platform: apple m1 amd64/ ubuntu
export PLATFORM=amd64
export HOST_IP=$(ipconfig getifaddr en0)
export SHARED_DIR=~/mlrun-data
mkdir $SHARED_DIR -p
docker compose -f compose-mlrun.yaml $1