# Makefile

# 初期セットアップ
init:
	make clone

init-db:
	sudo chmod -R 777 services/database/mysql/db
	sudo chown -R 999:999 services/database/mysql/db

ssl:
	mkdir -p ./nginx/certs ./nginx/logs ./nginx/html
	docker run --rm -it \
  -v "./nginx/certs:/etc/letsencrypt" \
  -v "./nginx/html:/var/www/certbot" \
  certbot/certbot certonly \
  --webroot \
  --webroot-path=/var/www/certbot \
  --agree-tos \
  --email infol@ffoffa.com \
  -d ffoffa.net -d www.ffoffa.net
	chmod +x /srv/nginx/cert_renew.sh

clone:
	git clone git@github.com:ytakehir/ffoffa_lipAdviser_next.git ./services/frontend/ffoffa
	git clone git@github.com:ytakehir/ffoffa_LipAdviser_API.git ./services/backend/lipAdviser

build:
	docker compose build --no-cache

# 擬似関数: サービスのビルドと起動
define build_and_start
	@echo "Building $1..."
	@if [ "$(ENV)" = "prod" ]; then \
		docker compose -f docker-compose.yml --env-file .env.prod build $1; \
	else \
		docker compose -f docker-compose.yml -f docker-compose.override.dev.yml --env-file .env.$(ENV) build $1; \
	fi
	@echo "Starting $1..."
	@if [ "$(ENV)" = "prod" ]; then \
		docker compose -f docker-compose.yml --env-file .env.prod up -d $1; \
	else \
		docker compose -f docker-compose.yml -f docker-compose.override.dev.yml --env-file .env.$(ENV) up -d $1; \
	fi
endef

# サービスのビルドと起動
start:
	@if [ -z "$(ENV)" ]; then echo "Usage: make start ENV=<env>"; exit 1; fi
	@echo "Using environment: $(ENV)"
	@echo "Building and starting backend mysql and backend..."
	$(call build_and_start, mysql backend)
	@echo "Waiting for backend to be ready..."
	@until curl -s http://localhost:5000/test > /dev/null; do \
		sleep 2; \
		echo "Waiting..."; \
	done
	@echo "Backend is ready!"
	@echo "Building and starting frontend..."
	$(call build_and_start, frontend)
	@echo "Building and starting nginx and certbot..."
	$(call build_and_start, nginx certbot)
	@echo "All services are up and running!"

# コンテナの起動
up:
	@if [ -z "$(ENV)" ]; then echo "Usage: make start ENV=<env>"; exit 1; fi
	docker compose --env-file .env.$(ENV) up -d

# コンテナの停止
down:
	@if [ -z "$(ENV)" ]; then echo "Usage: make start ENV=<env>"; exit 1; fi
	docker compose --env-file .env.$(ENV) down

# ログの確認
logs:
	@if [ -z "$(ENV)" ]; then echo "Usage: make start ENV=<env>"; exit 1; fi
	docker compose --env-file .env.$(ENV) logs -f

clean:
	rm -rf ./services/frontend/ffoffa
	rm -rf ./services/backend/lipAdviser

clear:
	docker system prune --all --volumes --force
