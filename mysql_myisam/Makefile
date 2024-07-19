# Variables
COMPOSE_FILE=docker-compose.yaml
SERVICE_NAME=mysql
CONTAINER_NAME=mysql57_myisam

# Commands
start:
	docker compose -f $(COMPOSE_FILE) up -d

stop:
	docker compose -f $(COMPOSE_FILE) down

bash:
	docker exec -it $(CONTAINER_NAME) bash

mysql:
	docker exec -it $(CONTAINER_NAME) mysql -utest -ptest myisam_test
