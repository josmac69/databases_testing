.PHONY: start stop clean mysql-client

start:
	docker compose up -d

stop:
	docker compose down

clean:
	docker compose down -v

mysql-client:
	docker compose exec mysql-client mysql -h tidb -P 4000 -u root
