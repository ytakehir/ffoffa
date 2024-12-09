# Makefile

# 初期セットアップ
init:
	make clone
	docker-compose build

clone:
	git clone git@github.com:ytakehir/ffoffa_lipAdviser_next.git ./services/frontend/ffoffa
	git clone git@github.com:ytakehir/ffoffa_LipAdviser_API.git ./services/backend/lipAdviser

# Nginx 環境の準備
nginx-init:
	docker build -t nginx-service ./nginx

# コンテナの起動
up:
	make nginx-init
	docker-compose up -d

# コンテナの停止
down:
	docker-compose down

# ログの確認
logs:
	docker-compose logs -f

clean:
	rm -rf ./services/frontend/ffoffa
	rm -rf ./services/backend/lipAdviser