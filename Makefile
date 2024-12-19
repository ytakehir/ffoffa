# Makefile

# 初期セットアップ
init:
	make clone
	docker compose build --no-cache

clone:
	git clone git@github.com:ytakehir/ffoffa_lipAdviser_next.git ./services/frontend/ffoffa
	git clone git@github.com:ytakehir/ffoffa_LipAdviser_API.git ./services/backend/lipAdviser

build:
	docker compose build --no-cache

# Nginx 環境の準備
nginx-init:
	docker build -t nginx-service ./nginx

# コンテナの起動
up:
	docker compose up -d

up-dev:
	docker compose --env-file .env.local up -d

up-prod:
	docker compose --env-file .env.prod up -d

# コンテナの停止
down:
	docker compose down

# ログの確認
logs:
	docker compose logs -f

clean:
	rm -rf ./services/frontend/ffoffa
	rm -rf ./services/backend/lipAdviser