# container start
sudo docker-compose up -d

# access db
psql -h localhost -p 5432 -d my_db -U root
psql -h localhost -p 5433 -d my_db -U root
psql -h localhost -p 5434 -d my_db -U root
