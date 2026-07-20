.PHONY: serve test check docker-up docker-down

serve:
	PORT=8013 APP_HOST=127.0.0.1 geblang src/main.gb

serve-docker:
	docker run --rm -p 8013:8013 \
		-e PORT=8013 -e APP_HOST=0.0.0.0 \
		-e DB_DATABASE=/app/database/database.sqlite \
		-e JWT_SECRET=$${JWT_SECRET:-dev-secret} \
		-v "$$(pwd)":/app -w /app dwgebler/geblang:1.32.0 \
		src/main.gb

test:
	geblang test tests/ -v

test-docker:
	docker run --rm -v "$$(pwd)":/app -w /app dwgebler/geblang:1.32.0 test tests/ -v

check:
	geblang check src/

docker-up:
	docker compose up --build

docker-down:
	docker compose down
