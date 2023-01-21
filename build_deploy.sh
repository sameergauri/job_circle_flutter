# "./mvnw" clean install -f "/Users/work/Paid/api/pom.xml" -DskipTests

flutter build web --release
# docker build -f Dockerfile -t pratikdock/jbcrcl:latest .

# docker push pratikdock/jbcrcl:latest

#!/bin/sh

# Stop script on first error
set -e

DOCKER_USERNAME="pratikdock"
DOCKER_PASSWORD="pratik@1111"
SSH_KEY="~/Desktop/jobcircle.cer"
SERVER_IP="ubuntu@ec2-13-232-140-47.ap-south-1.compute.amazonaws.com"
IMAGE_NAME="pratikdock/jbcweb"
LOCAL_IMAGE_NAME="jbcweb"
IMAGE_TAG="latest" # first 7 characters of the current commit hash
SSH_COMMAND=""



echo ssh -i "/Users/admin/Desktop/jobcircle.cer" ubuntu@ec2-13-232-140-47.ap-south-1.compute.amazonaws.com "sudo docker pull ${IMAGE_NAME}:latest && sudo docker stop ${LOCAL_IMAGE_NAME} && sudo docker rm ${LOCAL_IMAGE_NAME} && sudo docker run -dit --name ${LOCAL_IMAGE_NAME} -p 9091:80 ${IMAGE_NAME}:latest && sudo docker system prune -af"

echo "Building Docker image ${IMAGE_NAME}:${IMAGE_TAG}, and tagging as latest"
# docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .
# docker tag "${IMAGE_NAME}:${IMAGE_TAG}" "${IMAGE_NAME}:latest"
docker build -f Dockerfile -t "${IMAGE_NAME}:${IMAGE_TAG}" .

echo "Authenticating and pushing image to Docker Hub"
echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
#docker push "${IMAGE_NAME}:${IMAGE_TAG}"
docker push "${IMAGE_NAME}:${IMAGE_TAG}"

# Decode SSH key
#echo "${SSH_KEY}" | base64 -d > ssh_key
#chmod 600 ssh_key # private keys need to have strict permission to be accepted by SSH agent

# Add production server to known hosts
#echo "${SERVER_PUBLIC_KEY}" | base64 -d >> ~/.ssh/known_hosts

echo "Deploying via remote SSH"
# ssh -i  "${SSH_KEY} ubuntu@${SERVER_IP}" \
#   "docker pull ${IMAGE_NAME}:${IMAGE_TAG} \
#   && docker stop jobapi \
#   && docker rm jobapi \
#   && docker run -dit --name jobapi -p 9090:9090 ${IMAGE_NAME}:${IMAGE_TAG} \
#   && docker system prune -af" # remove unused images to free up space



ssh -i "/Users/admin/Desktop/jobcircle.cer" ubuntu@ec2-13-232-140-47.ap-south-1.compute.amazonaws.com "sudo docker pull ${IMAGE_NAME}:latest && sudo docker stop ${LOCAL_IMAGE_NAME} && sudo docker rm ${LOCAL_IMAGE_NAME} && sudo docker run -dit --name ${LOCAL_IMAGE_NAME} -p 9091:80 ${IMAGE_NAME}:latest && sudo docker system prune -af"


echo "Successfully deployed, hooray!"