# build
sudo docker image build -t postgres10 .

# create container
sudo docker container run -d -p 5432:5432 --name pg-primary postgres10

sudo docker container run -d -p 5433:5432 --name pg-standby1 postgres10

sudo docker container run -d -p 5434:5432 --name pg-standby2 postgres10

