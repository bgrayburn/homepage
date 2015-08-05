docker kill homepage
docker rm homepage
docker run -it --name=homepage --link mongodb:mongodb --rm -p 80:80 -v "$(pwd)":/app -e "MONGO_URL=mongodb://mongodb/meteor" danieldent/meteor meteor -p 80
#docker run -it --name=homepage --link mongodb:mongodb --rm -p 3000:3000 -v "$(pwd)":/app danieldent/meteor meteor 
