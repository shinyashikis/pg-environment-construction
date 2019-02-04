# build
sudo docker image build -t postgres10 .

# create container
sudo docker container run -it -p 5432:5432 --name pg-primary postgres10

sudo docker container run -it -p 5432:5432 --name pg-stanby1 postgres10

sudo docker container run -it -p 5432:5432 --name pg-stanby2 postgres10

