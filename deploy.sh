sudo mkdir -p /data/project/project-pgdata
sudo chown -R $USER:$USER /data/project/project-pgdata

docker network create projectnet
docker compose up -d
watch docker ps -a

# Open project
# docker run -it -p '7777:8080' \
#   --name openproject \
#   -e OPENPROJECT_SECRET_KEY_BASE=openproject \
#   -e OPENPROJECT_HTTPS=false \
#   -e OPENPROJECT_DEFAULT__LANGUAGE=en \
#   -e DATABASE_URL=postgres://manager:project@db:5432/openproject \
#   --network projectnet \
#   -d openproject/community:13
